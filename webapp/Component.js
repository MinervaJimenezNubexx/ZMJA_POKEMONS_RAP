sap.ui.define([
    "sap/ui/core/UIComponent",
    "sap/ui/model/json/JSONModel",
    "sap/m/Dialog",
    "sap/m/Button",
    "sap/m/Select",
    "sap/ui/core/Item",
    "sap/m/Label",
    "sap/m/VBox",
    "sap/m/Input",
    "sap/ui/model/Filter",
    "sap/ui/model/FilterOperator"
], function (UIComponent, JSONModel, Dialog, Button, Select, Item, Label, VBox, Input, Filter, FilterOperator) {
    "use strict";

    return UIComponent.extend("com.nbx.pokerap.Component", {
        metadata: { manifest: "json" },

        init: function () {
            this.setModel(new JSONModel({ layout: "OneColumn" }), "appView");
            this.setModel(new JSONModel({ rol: "" }), "permissions");
            this._o18n = this.getModel("i18n").getResourceBundle();
            UIComponent.prototype.init.apply(this, arguments);
            this._showRoleSelector();
        },

        _showRoleSelector: function () {
            const oEmailBox = new VBox("idEmailBox", {
                visible: false,
                items: [
                    new Label({ text: (this._o18n.getText('loginTrainerEmail')), design: "Bold" }).addStyleClass("sapUiSmallMarginTop"),
                    new Input("idTrainerEmail", { placeholder: this._o18n.getText('loginEmailPlaceholder') })
                ]
            });

            const oDialog = new Dialog({
                title: this._o18n.getText('loginTitle'),
                contentWidth: "300px",
                content: new VBox({
                    items: [
                        new Label({ text: this._o18n.getText('loginSelectRole') }),
                        new Select("idRoleSelect", {
                            width: "100%",
                            items: [
                                new Item({ key: "Manager", text: "Manager" }),
                                new Item({ key: "Trainer", text: "Trainer" }),
                                new Item({ key: "Viewer", text: "Viewer" })
                            ],
                            change: function(oEvent) {
                                const sSelected = oEvent.getParameter("selectedItem").getKey();
                                oEmailBox.setVisible(sSelected === "Trainer");
                            }
                        }),
                        oEmailBox
                    ]
                }).addStyleClass("sapUiSmallMargin"),
                
                beginButton: new Button({
                    text: this._o18n.getText('loginButton'),
                    type: "Emphasized",
                    press: function () {
                        const sRole = sap.ui.getCore().byId("idRoleSelect").getSelectedKey();
                        const sEmail = sap.ui.getCore().byId("idTrainerEmail").getValue();

                        if (sRole === "Trainer" && !sEmail) {
                            sap.m.MessageToast.show(this._o18n.getText('loginErrorEnterEmail'));
                            return;
                        }

                        oDialog.close();
                        this._loadPermissionsAndNavigate(sRole, sEmail);
                    }.bind(this)
                })
            });

            oDialog.open();
        },

        _loadPermissionsAndNavigate: function (sRoleName, sEmail) {
            const oModel = this.getModel();
            const oPermissionsModel = this.getModel("permissions");

            sap.ui.core.BusyIndicator.show(0);

            const oRoleBinding = oModel.bindList("/Roles", null, null, [
                new Filter("Rolname", FilterOperator.EQ, sRoleName)
            ]);

            oRoleBinding.requestContexts(0, 1).then(function (aContexts) {
                if (aContexts.length === 0) throw new Error(this._o18n.getText('loginErrorUndefinedRole'));

                const oRoleData = aContexts[0].getObject();
                oPermissionsModel.setData({
                    rol: oRoleData.Rolname,
                    edit: oRoleData.Edit,
                    viewer: oRoleData.Viewer,
                    admin: oRoleData.Admin,
                    capture: oRoleData.Capturepokemon,
                    email: sEmail
                });

                if (sRoleName === "Trainer") {
                    const oTrainerBinding = oModel.bindList("/Trainers", null, null, [
                        new Filter("Email", FilterOperator.EQ, sEmail)
                    ]);

                    return oTrainerBinding.requestContexts(0, 1);
                } else {
                    this.getRouter().initialize();
                    sap.ui.core.BusyIndicator.hide();
                }
            }.bind(this)).then(function (aTrainerContexts) {
                if (sRoleName === "Trainer") {
                    sap.ui.core.BusyIndicator.hide();
                    if (aTrainerContexts && aTrainerContexts.length > 0) {
                        const sId = aTrainerContexts[0].getProperty("Trainerid");
                        
                        this.getRouter().initialize();
                        this.getRouter().navTo("RouteTeams", { 
                            trainerId: sId,
                            isActive: true 
                        });
                        this.getModel("appView").setProperty("/layout", "MidColumnFullScreen");
                    } else {
                        sap.m.MessageBox.error(this._o18n.getText('loginErrorUndefinedEmail'));
                    }
                }
            }.bind(this)).catch(function (oError) {
                sap.ui.core.BusyIndicator.hide();
                sap.m.MessageBox.error(this._o18n.getText('loginError') + ' ' + oError.message);
            }.bind(this));
        }
    });
});