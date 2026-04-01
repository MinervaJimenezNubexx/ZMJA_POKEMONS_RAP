sap.ui.define([
    "./BaseController",
    "sap/ui/model/json/JSONModel",
    "sap/m/MessageToast",
    "sap/m/MessageBox",
    "sap/ui/core/Fragment",
    "sap/ui/core/routing/History",
    "../util/constants"
], (BaseController, JSONModel, MessageToast, MessageBox, Fragment, History, Constants) => {
    "use strict";

    return BaseController.extend("com.nbx.pokerap.controller.Detail", {
        onInit() {
            var oRouter = this.getRouter();
            oRouter.getRoute("RouteTeams").attachMatched(this.onRouteMatched, this);

            this._o18n = this.getResourceBundle();

            //Local model for capturing random pokemons
            let oRandomPokemonModel = new JSONModel({});
            this.getView().setModel(oRandomPokemonModel, "randomPokemon");
            //debugger;

            //local model for creating new team
            let oTeamModel = new JSONModel({
                Name: "",
                Active: false //inactive by default
            });

            this.getView().setModel(oTeamModel, "newTeam");
        },

        onRouteMatched: function (oEvent) {
            //debugger;
            this._sTrainerId = oEvent.getParameter("arguments").trainerId;
            let bIsActive = oEvent.getParameter("arguments").isActive;

            let oPermissionsModel = this.getView().getModel("permissions");
            if (oPermissionsModel) {
                let sRol = oPermissionsModel.getProperty("/rol");

                if (sRol === "Trainer") {
                    this.getView().getModel("appView").setProperty("/layout", "MidColumnFullScreen");
                } else {
                    this.getView().getModel("appView").setProperty("/layout", "TwoColumnsMidExpanded");
                }
            }

            this.getView().bindElement({
                path: "/Trainers(Trainerid=" + this._sTrainerId + ",IsActiveEntity=" + bIsActive + ")",
                parameters: {
                    $expand: "_Teams"
                }
            });
        },

        onCloseDetail: function () {
            let oHistory = History.getInstance(),
                sPreviousHash = oHistory.getPreviousHash();

            if (sPreviousHash !== undefined) {
                window.history.go(-1);
            } else {
                this.getRouter().navTo("RouteMain");
            }
        },

        //NAVIGATION TO CAPTURES

        onPressItem: function (oEvent) {
            let oItem = oEvent.getParameter("listItem"),
                oContext = oItem.getBindingContext(),
                oRouter = this.getRouter();

            let sPath = oContext.getPath(),
                sEncodedPath = encodeURIComponent(sPath);

            oRouter.navTo("RouteCaptures", {
                contextPath: sEncodedPath
            });
        },

        // CAPTURE RANDOM POKEMONS

        onSearchRandomPokemon: function () {
            let iRandomPokedex = Math.floor(Math.random() * 151) + 1,
                oModel = this.getView().getModel();

            sap.ui.core.BusyIndicator.show(0);

            let oContextBinding = oModel.bindContext("/Pokemons(" + iRandomPokedex + ")", null, {
                "$select": "Nombre,Altura,Peso"
            });

            oContextBinding.requestObject().then((oPokemonData) => {
                sap.ui.core.BusyIndicator.hide();

                let sNombre = oPokemonData.Nombre || oPokemonData.nombre || oPokemonData.NOMBRE || "Desconocido",
                    sAltura = oPokemonData.Altura || oPokemonData.altura || oPokemonData.ALTURA || 0,
                    sPeso = oPokemonData.Peso || oPokemonData.peso || oPokemonData.PESO || 0;

                this.getView().getModel("randomPokemon").setData({
                    Nombre: sNombre,
                    Altura: sAltura,
                    Peso: sPeso
                });

                if (!this._catchDialog) {
                    sap.ui.core.Fragment.load({
                        id: this.getView().getId(),
                        name: "com.nbx.pokerap.view.fragment.catchPokemonDialog",
                        controller: this
                    }).then(function (oDialog) {
                        this._catchDialog = oDialog;
                        this.getView().addDependent(this._catchDialog);
                        this._catchDialog.open();
                    }.bind(this));
                } else {
                    this._catchDialog.open();
                }

            }).catch((oError) => {
                sap.ui.core.BusyIndicator.hide();
                sap.m.MessageBox.error(this._o18n.getText('findRandomPokemonError') + oError.message);
            });
        },

        onCancelCapture: function () {
            if (this._catchDialog) {
                this._catchDialog.close();
            }
        },

        onCapturePokemon: function () {
            let oSelect = this.byId("teamSelector"),
                oSelectedItem = oSelect.getSelectedItem();

            if (!oSelectedItem) {
                sap.m.MessageBox.warning(this._o18n.getText('noTeamSelectedWarning'));
                return;
            }

            let oModel = this.getView().getModel(),
                oPokemonData = this.getView().getModel("randomPokemon").getData(),
                sNamespace = "com.sap.gateway.srvd.zmja_ui_trainers.v0001",
                sTrainerId = this._sTrainerId,
                sTeamId = oSelectedItem.getBindingContext().getProperty("Teamid"),
                sDraftTrainerPath = "/Trainers(Trainerid=" + sTrainerId + ",IsActiveEntity=false)",
                sDraftCapturePath = sDraftTrainerPath + "/_Teams(Teamid=" + sTeamId + ",IsActiveEntity=false)/_Captures";

            sap.ui.core.BusyIndicator.show(0);

            let oActiveTrainerContext = this.getView().getBindingContext(),
                oEditAction = oModel.bindContext(sNamespace + ".Edit(...)", oActiveTrainerContext);
            oEditAction.setParameter("PreserveChanges", true);

            oEditAction.execute().then(() => {
                let sGroupId = "captureGroup",
                    oListBinding = oModel.bindList(sDraftCapturePath, null, [], [], { $$updateGroupId: sGroupId });

                let oContext = oListBinding.create({
                    Nombre: oPokemonData.Nombre,
                    Altura: parseInt(oPokemonData.Altura),
                    Peso: parseInt(oPokemonData.Peso)
                });
                oModel.submitBatch(sGroupId);

                return oContext.created();

            }).then(() => {
                let oDraftBinding = oModel.bindContext(sDraftTrainerPath);
                return oDraftBinding.requestObject().then(() => oDraftBinding.getBoundContext());

            }).then((oDraftContext) => {
                let oActivateAction = oModel.bindContext(sNamespace + ".Activate(...)", oDraftContext);
                return oActivateAction.execute();

            }).then(() => {

                sap.ui.core.BusyIndicator.hide();
                sap.m.MessageToast.show(this._o18n.getText('MessagePokmnCaptured'));

                if (this._catchDialog) {
                    this._catchDialog.close();
                }

                this.getView().getBindingContext().refresh();

            }).catch((oError) => {
                let oDraftBinding = oModel.bindContext(sDraftTrainerPath);

                oDraftBinding.requestObject().then(() => {
                    let oDiscardAction = oModel.bindContext(sNamespace + ".Discard(...)", oDraftBinding.getBoundContext());
                    oDiscardAction.execute();
                }).finally(() => {
                    sap.ui.core.BusyIndicator.hide();
                    sap.m.MessageBox.error(this._o18n.getText('MessageErrorPokmnCaptured') + oError.message);
                });
            });
        },

        //CREATE NEW TEAM

        onOpenAddTeamDialog: function () {
            this.getView().getModel("newTeam").setData({
                Name: "",
                Active: false
            });

            if (!this._addTeamDialog) {
                sap.ui.core.Fragment.load({
                    id: this.getView().getId(),
                    name: "com.nbx.pokerap.view.fragment.addTeamDialogUser",
                    controller: this
                }).then(function (oDialog) {
                    this._addTeamDialog = oDialog;
                    this.getView().addDependent(this._addTeamDialog);
                    this._addTeamDialog.open();
                }.bind(this));
            } else {
                this._addTeamDialog.open();
            }


        },

        onCloseTeamDialog: function () {
            if (this._addTeamDialog) {
                this._addTeamDialog.close();
            }
        },

        onSaveTeam: function () {
            let oModel = this.getView().getModel(),
                oData = this.getView().getModel("newTeam").getData();

            if (!oData.Name) {
                MessageBox.warning(this._o18n.getText('FillAllRequiredUserTeam'));
                return;
            }

            sap.ui.core.BusyIndicator.show(0);

            let oTrainerContext = this.getView().getBindingContext(),
                sTrainerId = this._sTrainerId,
                sDraftTrainerPath = "/Trainers(Trainerid=" + sTrainerId + ",IsActiveEntity=false)",
                sNamespace = "com.sap.gateway.srvd.zmja_ui_trainers.v0001",
                oEditAction = oModel.bindContext(sNamespace + ".Edit(...)", oTrainerContext);
            oEditAction.setParameter("PreserveChanges", true);

            oEditAction.execute().then(() => {
                let oListBinding = oModel.bindList(sDraftTrainerPath + "/_Teams"),
                    oContext = oListBinding.create({
                        Name: oData.Name,
                        Status: oData.Active
                    });

                return oContext.created();

            }).then(() => {
                let oDraftBinding = oModel.bindContext(sDraftTrainerPath);
                return oDraftBinding.requestObject().then(() => {
                    return oDraftBinding.getBoundContext();
                });

            }).then((oDraftContext) => {

                let oActivateAction = oModel.bindContext(sNamespace + ".Activate(...)", oDraftContext);
                return oActivateAction.execute();

            }).then(() => {

                sap.ui.core.BusyIndicator.hide();
                MessageToast.show(this._o18n.getText('TeamAddedUser'));
                if (this._addTeamDialog) {
                    this._addTeamDialog.close();
                }

                this.getView().getBindingContext().refresh();

            }).catch((oError) => {
                sap.ui.core.BusyIndicator.hide();
                MessageBox.error(this._o18n.getText('TeamAddedErrorUser') + oError.message);
            });
        }
    });
});