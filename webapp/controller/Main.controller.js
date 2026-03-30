sap.ui.define([
    "./BaseController",
    "sap/ui/model/json/JSONModel",
    "sap/m/MessageToast",
    "sap/m/MessageBox"
], (BaseController, JSONModel, MessageToast, MessageBox) => {
    "use strict";

    return BaseController.extend("com.nbx.pokerap.controller.Main", {
        onInit() {
            this._o18n = this.getResourceBundle();

            //local model to add a new trainer
            let oViewModel = new JSONModel({
                firstName: "",
                lastName: "",
                Email: "",
                BirthDate: null
            });

            this.getView().setModel(oViewModel, "newTrainer");

            //local model to add a new team for a trainer
            let oTeamModel = new JSONModel({
                Name: "",
                Active: false //inactive by default
            });

            this.getView().setModel(oTeamModel, "newTeam");
        },

        //CREATING NEW TRAINER

        onAddDocument: function (oEvent) {
            this.getView().getModel("newTrainer").setData({
                firstName: "",
                lastName: "",
                Email: "",
                BirthDate: null
            });

            if (!this._addTrainerDialog) {
                sap.ui.core.Fragment.load({
                    id: this.getView().getId(),
                    name: "com.nbx.pokerap.view.fragment.addTrainerDialog",
                    controller: this
                }).then(function (oDialog) {
                    this._addTrainerDialog = oDialog;
                    this.getView().addDependent(this._addTrainerDialog);
                    this._addTrainerDialog.open();
                }.bind(this));
            } else {
                this._addTrainerDialog.open();
            }
        },

        onCloseWizard: function () {
            if (this._addTrainerDialog) {
                this._addTrainerDialog.close();
            }
        },

        onSaveTrainer: function () {
            let oModel = this.getView().getModel();
            let oData = this.getView().getModel("newTrainer").getData();

            if (!oData.firstName || !oData.lastName || !oData.Email || !oData.BirthDate) {
                MessageBox.warning(this._o18n.getText('FillAllRequiredTrainer'));
                return;
            }

            let oListBinding = oModel.bindList("/Trainers");

            let oContext = oListBinding.create({
                Firstname: oData.firstName,
                Lastname: oData.lastName,
                Email: oData.Email,
                Birthdate: oData.BirthDate
            });

            sap.ui.core.BusyIndicator.show(0);

            oContext.created().then(() => {
                let sNamespace = "com.sap.gateway.srvd.zmja_ui_trainers.v0001";
                let oAction = oModel.bindContext(sNamespace + ".Activate(...)", oContext);

                return oAction.execute();

            }).then(() => {
                sap.ui.core.BusyIndicator.hide();
                MessageToast.show(this._o18n.getText('TrainerAdded'));
                this.onCloseWizard();
                oModel.refresh();

            }).catch((oError) => {
                sap.ui.core.BusyIndicator.hide();
                MessageBox.error(oError.message);

                let sNamespace = "com.sap.gateway.srvd.zmja_ui_trainers.v0001";
                let oDiscardAction = oModel.bindContext(sNamespace + ".Discard(...)", oContext);

                oDiscardAction.execute().then(() => {
                    oModel.refresh();
                });
            });
        },

        //NAVIGATION TO DETAIL VIEW

        onPressItem: function (oEvent) {

            let oContext = oEvent.getSource().getSelectedItems()[0].getBindingContext(),
                oItem = oContext.getObject(),
                oRouter = this.getRouter();

            //debugger;
            oRouter.navTo("RouteTeams", {
                trainerId: oItem.Trainerid,
                isActive: oItem.IsActiveEntity
            });
        },

        //CREATING NEW TEAM FOR A TRAINER

        onOpenAddTeamDialog: function () {
            this.getView().getModel("newTeam").setData({
                Name: "",
                Active: false
            });

            if (!this._addTeamDialog) {
                sap.ui.core.Fragment.load({
                    id: this.getView().getId(),
                    name: "com.nbx.pokerap.view.fragment.addTeamDialog",
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
                oData = this.getView().getModel("newTeam").getData(),
                oSelect = this.byId("trainerSelectorAdmin"),
                oSelectedItem = oSelect.getSelectedItem();

            if (!oData.Name) {
                MessageBox.warning(this._o18n.getText('FillAllRequiredTeam'));
                return;
            }
            if (!oSelectedItem) {
                MessageBox.warning(this._o18n.getText('SelectTrainer'));
                return;
            }

            sap.ui.core.BusyIndicator.show(0);

            let sNamespace = "com.sap.gateway.srvd.zmja_ui_trainers.v0001",
                oTrainerContext = oSelectedItem.getBindingContext(),
                sTrainerId = oTrainerContext.getProperty("Trainerid"),
                sDraftTrainerPath = "/Trainers(Trainerid=" + sTrainerId + ",IsActiveEntity=false)",
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
                MessageToast.show(this._o18n.getText('TeamAdded'));
                if (this._addTeamDialog) {
                    this._addTeamDialog.close();
                }
                oModel.refresh();

            }).catch((oError) => {
                sap.ui.core.BusyIndicator.hide();
                MessageBox.error("Error: " + (oError.message || "No se pudo crear el equipo"));
            });
        }
    });
});