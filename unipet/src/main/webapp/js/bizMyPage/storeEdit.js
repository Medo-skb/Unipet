const app = Vue.createApp({
        data() {
            return {
                userInfo: {
                    sUserId: "",
                    ceoName: ""
                },
                hasApprovedStore: true,
                approvedStoreMessage: "",
                storeInfo: {
                    storeNo: "",
                    storeName: "",
                    sCategory: "",
                    biznum: "",
                    isOpen: "",
                    accName: "",
                    accNo: "",
                    accHolder: "",
                    sAddr: "",
                    sFullAddr: "",
                    subTitle: "",
                    sContents: "",
                    capacity: "",
                    cutoff: "",
                    openTime: "",
                    closeTime: "",
                    breakStart: "",
                    breakEnd: "",
                    slot: "",
                    refundPolicy: "",
                    sStatus: "",
                    rejReason: ""
                },
                fileList: [],
                menuList: [],

                showPostcodeLayer: false,
                showStoreEditModal: false,
                showMenuEditModal: false,
                showMenuAddModal: false,
                showRejectedStoreEditModal: false,
                isGeocoding: false,

                editStoreInfo: {
                    storeNo: "",
                    storeName: "",
                    sCategory: "",
                    biznum: "",
                    lat: "",
                    lng: "",
                    isOpen: "",
                    accName: "",
                    accNo: "",
                    accHolder: "",
                    sAddr: "",
                    sFullAddr: "",
                    subTitle: "",
                    sContents: "",
                    capacity: "",
                    cutoff: "",
                    openTime: "",
                    closeTime: "",

                    openAmpm: "",
                    openHour: "",
                    openMinute: "",
                    closeAmpm: "",
                    closeHour: "",
                    closeMinute: "",

                    breakStart: "",
                    breakEnd: "",

                    breakStartAmpm: "",
                    breakStartHour: "",
                    breakStartMinute: "",
                    breakEndAmpm: "",
                    breakEndHour: "",
                    breakEndMinute: "",

                    slot: "",
                    refundPolicy: ""
                },

                editMenuList: [],
                deleteMenuNoList: [],

                addMenuInput: {
                    menuName: "",
                    menuPrice: ""
                },
                addMenuList: [],
                capacityOptions: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20],
                hourOptions: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],

                showMyInfoEditModal: false,
                isIdChecked: false,
                
                editUserInfo: {
                    sUserId: "",
                    ceoName: ""
                },

                isIdChecked: false,
                
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
        fnCheckApprovedStore: function() {
            let self = this;

            $.ajax({
                url: "/getApprovedStore.dox",
                type: "POST",
                dataType: "json",
                data: {
                    sUserId: window.storeEditConfig.sessionId
                },
                success: function(data) {
                if (data.result === "success" && data.list && data.list.length > 0) {
                    self.storeInfo = data.list[0];

                    if (self.storeInfo.sStatus === "GEN" || self.storeInfo.sStatus === "AFF") {
                            self.hasApprovedStore = true;
                            self.approvedStoreMessage = "";
                            self.fnGetStoreInfo();
                            self.fnGetFileList();
                            self.fnGetMenuList();
                        } else {
                            self.hasApprovedStore = false;
                            self.fileList = [];
                            self.menuList = [];

                            if (self.storeInfo.sStatus === "REJ") {
                                self.approvedStoreMessage = "사업자 승인이 반려되었습니다.";

                                if (self.storeInfo.rejReason) {
                                    self.approvedStoreMessage += "\n반려 사유: " + self.storeInfo.rejReason;
                                }
                            } else if (self.storeInfo.sStatus === "PND") {
                                self.approvedStoreMessage = "사업자 승인 대기중입니다.";
                            } else {
                                self.approvedStoreMessage = "승인된 업체가 없습니다.";
                            }
                        }
                    } else {
                        self.hasApprovedStore = false;
                        self.approvedStoreMessage = "승인된 업체가 없습니다.";

                        self.storeInfo = {
                            storeNo: "",
                            storeName: "",
                            sCategory: "",
                            biznum: "",
                            isOpen: "",
                            accName: "",
                            accNo: "",
                            accHolder: "",
                            sAddr: "",
                            sFullAddr: "",
                            subTitle: "",
                            sContents: "",
                            capacity: "",
                            cutoff: "",
                            openTime: "",
                            closeTime: "",
                            breakStart: "",
                            breakEnd: "",
                            refundPolicy: "",
                            sStatus: "",
                            rejReason: ""
                        };

                        self.fileList = [];
                        self.menuList = [];
                    }
                },
                error: function() {
                    alert("승인된 업체 확인 중 오류가 발생했습니다.");
                }
            });
        },

            fnRequestWithdraw: function() {
                let self = this;

                if (!confirm("정말 회원 탈퇴 하시겠습니까?")) {
                    return;
                }

                $.ajax({
                    url: "/biz/withdrawRequest.dox",
                    type: "POST",
                    dataType: "json",
                    data: {},
                    success: function(data) {
                        alert(data.message);

                        if (data.success) {
                            location.href = "/main.do";
                        }
                    },
                    error: function() {
                        alert("회원 탈퇴 처리 중 오류가 발생했습니다.");
                    }
                });
            },

            fnNormalizeTime: function(value) {
                if (!value) {
                    return "";
                }

                return String(value).substring(0, 5);
            },

            fnTimeToMinutes: function(time) {
                time = this.fnNormalizeTime(time);

                if (!time) {
                    return null;
                }

                let parts = time.split(":");
                return Number(parts[0]) * 60 + Number(parts[1]);
            },

            fnMinutesToTime: function(minutes) {
                let hour = Math.floor(minutes / 60);
                let minute = minutes % 60;

                return String(hour).padStart(2, "0") + ":" + String(minute).padStart(2, "0");
            },

            fnResetBreakTimeBySlot: function() {
                let self = this;

                if (Number(self.editStoreInfo.slot) === 60) {
                    if (self.editStoreInfo.openMinute === "30") {
                        self.editStoreInfo.openMinute = "";
                        self.editStoreInfo.openTime = "";
                    }

                    if (self.editStoreInfo.closeMinute === "30") {
                        self.editStoreInfo.closeMinute = "";
                        self.editStoreInfo.closeTime = "";
                    }
                }

                self.fnApplyOpenParts();
                self.fnApplyCloseParts();
                self.fnClearBreakTime();
            },

            fnGetMinuteOptions: function() {
                let slot = Number(this.editStoreInfo.slot || 30);

                if (slot === 60) {
                    return ["00"];
                }

                return ["00", "30"];
            },

            fnMakeTimeFromParts: function(ampm, hour, minute) {
                if (!ampm || !hour || minute === "") {
                    return "";
                }

                let h = Number(hour);
                let m = String(minute).padStart(2, "0");

                if (ampm === "AM") {
                    if (h === 12) {
                        h = 0;
                    }
                } else if (ampm === "PM") {
                    if (h !== 12) {
                        h += 12;
                    }
                }

                return String(h).padStart(2, "0") + ":" + m;
            },

            fnApplyOpenParts: function() {
                let self = this;

                self.editStoreInfo.openTime = self.fnMakeTimeFromParts(
                    self.editStoreInfo.openAmpm,
                    self.editStoreInfo.openHour,
                    self.editStoreInfo.openMinute
                );

                self.fnClearBreakTime();
            },

            fnApplyCloseParts: function() {
                let self = this;

                self.editStoreInfo.closeTime = self.fnMakeTimeFromParts(
                    self.editStoreInfo.closeAmpm,
                    self.editStoreInfo.closeHour,
                    self.editStoreInfo.closeMinute
                );

                self.fnClearBreakTime();
            },

            fnIsOpenCloseComplete: function() {
                let self = this;

                return !!(
                    self.editStoreInfo.openAmpm &&
                    self.editStoreInfo.openHour &&
                    self.editStoreInfo.openMinute !== "" &&
                    self.editStoreInfo.closeAmpm &&
                    self.editStoreInfo.closeHour &&
                    self.editStoreInfo.closeMinute !== ""
                );
            },

            fnGetBreakHourOptions: function(prefix) {
                let self = this;
                let result = [];

                let ampm = self.editStoreInfo[prefix + "Ampm"];

                if (!ampm || !self.editStoreInfo.openTime || !self.editStoreInfo.closeTime) {
                    return result;
                }

                let openMinutes = self.fnTimeToMinutes(self.editStoreInfo.openTime);
                let closeMinutes = self.fnTimeToMinutes(self.editStoreInfo.closeTime);
                let slot = Number(self.editStoreInfo.slot || 30);

                if (openMinutes == null || closeMinutes == null || closeMinutes <= openMinutes) {
                    return result;
                }

                for (let minutes = openMinutes; minutes <= closeMinutes; minutes += slot) {
                    let time = self.fnMinutesToTime(minutes);
                    let parts = time.split(":");
                    let hour24 = Number(parts[0]);

                    let optionAmpm = hour24 < 12 ? "AM" : "PM";
                    let hour12 = hour24 % 12;

                    if (hour12 === 0) {
                        hour12 = 12;
                    }

                    if (optionAmpm === ampm && result.indexOf(hour12) === -1) {
                        result.push(hour12);
                    }
                }

                return result;
            },

            fnGetBreakMinuteOptions: function(prefix) {
                let self = this;
                let result = [];

                let ampm = self.editStoreInfo[prefix + "Ampm"];
                let hour = self.editStoreInfo[prefix + "Hour"];

                if (!ampm || !hour || !self.editStoreInfo.openTime || !self.editStoreInfo.closeTime) {
                    return result;
                }

                let openMinutes = self.fnTimeToMinutes(self.editStoreInfo.openTime);
                let closeMinutes = self.fnTimeToMinutes(self.editStoreInfo.closeTime);
                let slot = Number(self.editStoreInfo.slot || 30);

                if (openMinutes == null || closeMinutes == null || closeMinutes <= openMinutes) {
                    return result;
                }

                for (let minutes = openMinutes; minutes <= closeMinutes; minutes += slot) {
                    let time = self.fnMinutesToTime(minutes);
                    let parts = time.split(":");
                    let hour24 = Number(parts[0]);
                    let minute = parts[1];

                    let optionAmpm = hour24 < 12 ? "AM" : "PM";
                    let hour12 = hour24 % 12;

                    if (hour12 === 0) {
                        hour12 = 12;
                    }

                    if (optionAmpm === ampm && Number(hour12) === Number(hour) && result.indexOf(minute) === -1) {
                        result.push(minute);
                    }
                }

                return result;
            },

            fnSetTimePartsFromTime: function(prefix, time) {
                let self = this;

                time = self.fnNormalizeTime(time);

                self.editStoreInfo[prefix + "Ampm"] = "";
                self.editStoreInfo[prefix + "Hour"] = "";
                self.editStoreInfo[prefix + "Minute"] = "";

                if (!time) {
                    return;
                }

                let parts = time.split(":");
                let hour24 = Number(parts[0]);
                let minute = parts[1];

                let ampm = hour24 < 12 ? "AM" : "PM";
                let hour12 = hour24 % 12;

                if (hour12 === 0) {
                    hour12 = 12;
                }

                self.editStoreInfo[prefix + "Ampm"] = ampm;
                self.editStoreInfo[prefix + "Hour"] = hour12;
                self.editStoreInfo[prefix + "Minute"] = minute;
            },

            fnApplyBreakStartParts: function() {
                let self = this;

                self.editStoreInfo.breakStart = self.fnMakeTimeFromParts(
                    self.editStoreInfo.breakStartAmpm,
                    self.editStoreInfo.breakStartHour,
                    self.editStoreInfo.breakStartMinute
                );

                self.editStoreInfo.breakEnd = "";
                self.editStoreInfo.breakEndAmpm = "";
                self.editStoreInfo.breakEndHour = "";
                self.editStoreInfo.breakEndMinute = "";
            },

            fnApplyBreakEndParts: function() {
                let self = this;

                self.editStoreInfo.breakEnd = self.fnMakeTimeFromParts(
                    self.editStoreInfo.breakEndAmpm,
                    self.editStoreInfo.breakEndHour,
                    self.editStoreInfo.breakEndMinute
                );
            },

            fnHasAnyBreakPart: function(prefix) {
                let self = this;

                return !!(
                    self.editStoreInfo[prefix + "Ampm"] ||
                    self.editStoreInfo[prefix + "Hour"] ||
                    self.editStoreInfo[prefix + "Minute"]
                );
            },

            fnIsBreakPartComplete: function(prefix) {
                let self = this;

                return !!(
                    self.editStoreInfo[prefix + "Ampm"] &&
                    self.editStoreInfo[prefix + "Hour"] &&
                    self.editStoreInfo[prefix + "Minute"] !== ""
                );
            },

            fnClearBreakTime: function() {
                let self = this;

                self.editStoreInfo.breakStart = "";
                self.editStoreInfo.breakEnd = "";

                self.editStoreInfo.breakStartAmpm = "";
                self.editStoreInfo.breakStartHour = "";
                self.editStoreInfo.breakStartMinute = "";

                self.editStoreInfo.breakEndAmpm = "";
                self.editStoreInfo.breakEndHour = "";
                self.editStoreInfo.breakEndMinute = "";
            },

            fnGetMyInfo: function () {
                let self = this;
                let param = {
                    sUserId: window.storeEditConfig.sessionId
                };

                $.ajax({
                    url: "/getBizUserInfo.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        if (data.info) {
                            self.userInfo = data.info;
                        } else {
                            self.userInfo = {
                                sUserId: "",
                                ceoName: "",
                                email: "",
                                phone: ""
                            };
                        }
                    },
                    error: function () {
                        alert("내 정보 조회에 실패했습니다.");
                    }
                });
            },

            fnGetStoreInfo: function() {
                let self = this;
                let param = {
                    sUserId: window.storeEditConfig.sessionId
                };

                $.ajax({
                    url: "/getBizStoreList.dox",
                    type: "POST",
                    dataType: "json",
                    data: param,
                    success: function(data) {
                        if (data.list && data.list.length > 0) {
                            self.storeInfo = data.list[0];
                        } else {
                            self.storeInfo = {
                                storeNo: "",
                                storeName: "",
                                sCategory: "",
                                biznum: "",
                                isOpen: "",
                                accName: "",
                                accNo: "",
                                accHolder: "",
                                sAddr: "",
                                sFullAddr: "",
                                subTitle: "",
                                sContents: "",
                                openTime: "",
                                closeTime: "",
                                breakStart: "",
                                breakEnd: "",
                                refundPolicy: ""
                            };
                        }
                    },
                    error: function() {
                        alert("업체 정보를 불러오는데 실패했습니다.");
                    }
                });
            },

            fnGetFileList: function() {
                let self = this;
                let param = {
                    sUserId: window.storeEditConfig.sessionId
                };

                $.ajax({
                    url: "/getBizImgList.dox",
                    type: "POST",
                    dataType: "json",
                    data: param,
                    success: function(data) {
                        if (data.list) {
                            self.fileList = data.list;
                        } else {
                            self.fileList = [];
                        }
                    },
                    error: function() {
                        alert("이미지 정보를 불러오는데 실패했습니다.");
                    }
                });
            },

            fnGetMenuList: function() {
                let self = this;
                let param = {
                    sUserId: window.storeEditConfig.sessionId
                };

                $.ajax({
                    url: "/getBizStoreMenuList.dox",
                    type: "POST",
                    dataType: "json",
                    data: param,
                    success: function(data) {
                        if (data.list) {
                            self.menuList = data.list;
                        } else {
                            self.menuList = [];
                        }
                    },
                    error: function() {
                        alert("업체 메뉴 정보를 불러오는데 실패했습니다.");
                    }
                });
            },

            fnEditRejectedStore: function() {
                let self = this;

                self.editStoreInfo = {
                    storeNo: self.storeInfo.storeNo,
                    storeName: self.storeInfo.storeName,
                    sCategory: self.storeInfo.sCategory,
                    biznum: self.storeInfo.biznum,
                    isOpen: self.storeInfo.isOpen,
                    accName: self.storeInfo.accName,
                    accNo: self.storeInfo.accNo,
                    accHolder: self.storeInfo.accHolder,
                    sAddr: self.storeInfo.sAddr,
                    sFullAddr: self.storeInfo.sFullAddr,
                    lat: self.storeInfo.lat,
                    lng: self.storeInfo.lng,
                    subTitle: self.storeInfo.subTitle,
                    sContents: self.storeInfo.sContents,
                    capacity: self.storeInfo.capacity,
                    cutoff: self.storeInfo.cutoff,
                    openTime: self.storeInfo.openTime,
                    closeTime: self.storeInfo.closeTime,
                    breakStart: self.storeInfo.breakStart,
                    breakEnd: self.storeInfo.breakEnd,
                    refundPolicy: self.storeInfo.refundPolicy
                };

                self.showRejectedStoreEditModal = true;
            },

            fnCloseRejectedStoreModal: function() {
                let self = this;
                self.showRejectedStoreEditModal = false;
                self.fnClosePostcode();
            },

            fnEditStoreInfo: function() {
                let self = this;

                self.editStoreInfo = {
                    storeNo: self.storeInfo.storeNo,
                    storeName: self.storeInfo.storeName,
                    sCategory: self.storeInfo.sCategory,
                    biznum: self.storeInfo.biznum,
                    isOpen: self.storeInfo.isOpen,
                    accName: self.storeInfo.accName,
                    accNo: self.storeInfo.accNo,
                    accHolder: self.storeInfo.accHolder,
                    sAddr: self.storeInfo.sAddr,
                    sFullAddr: self.storeInfo.sFullAddr,
                    lat: self.storeInfo.lat,
                    lng: self.storeInfo.lng,
                    subTitle: self.storeInfo.subTitle,
                    sContents: self.storeInfo.sContents,
                    capacity: self.storeInfo.capacity,
                    cutoff: self.storeInfo.cutoff,
                    openTime: self.fnNormalizeTime(self.storeInfo.openTime),
                    closeTime: self.fnNormalizeTime(self.storeInfo.closeTime),

                    openAmpm: "",
                    openHour: "",
                    openMinute: "",
                    closeAmpm: "",
                    closeHour: "",
                    closeMinute: "",

                    breakStart: self.fnNormalizeTime(self.storeInfo.breakStart),
                    breakEnd: self.fnNormalizeTime(self.storeInfo.breakEnd),

                    breakStartAmpm: "",
                    breakStartHour: "",
                    breakStartMinute: "",
                    breakEndAmpm: "",
                    breakEndHour: "",
                    breakEndMinute: "",

                    slot: self.storeInfo.slot || 30,
                    refundPolicy: self.storeInfo.refundPolicy
                };

                self.fnSetTimePartsFromTime("open", self.editStoreInfo.openTime);
                self.fnSetTimePartsFromTime("close", self.editStoreInfo.closeTime);
                self.fnSetTimePartsFromTime("breakStart", self.editStoreInfo.breakStart);
                self.fnSetTimePartsFromTime("breakEnd", self.editStoreInfo.breakEnd);

                self.showStoreEditModal = true;
            },

            fnCloseStoreEditModal: function() {
                let self = this;
                self.showStoreEditModal = false;
                self.fnClosePostcode();
            },

            fnEditMenu: function() {
                let self = this;

                self.deleteMenuNoList = [];

                self.editMenuList = self.menuList.map(function(item) {
                    return {
                        menuNo: item.menuNo,
                        storeNo: self.storeInfo.storeNo,
                        menuName: item.menuName,
                        menuCategory: item.menuCategory,
                        menuInfo: item.menuInfo,
                        menuPrice: item.menuPrice,
                        reqTime: Number(item.reqTime || 30),
                        mStatus: item.mStatus
                    };
                });

                self.showMenuEditModal = true;
            },

            fnOpenMenuAddModal: function() {
                let self = this;

                self.addMenuInput = {
                    menuName: "",
                    menuPrice: ""
                };

                self.addMenuList = [];
                self.showMenuAddModal = true;
            },

            fnCloseMenuAddModal: function() {
                let self = this;

                self.showMenuAddModal = false;

                self.addMenuInput = {
                    menuName: "",
                    menuPrice: ""
                };

                self.addMenuList = [];
            },

            fnAddMenuToAddList: function() {
                let self = this;

                let menuName = String(self.addMenuInput.menuName || "").trim();
                let menuPrice = Number(self.addMenuInput.menuPrice);

                if (!menuName) {
                    alert("메뉴명을 입력해주세요.");
                    return;
                }

                if (!menuPrice || menuPrice < 1000) {
                    alert("가격은 1000원 이상 입력해주세요.");
                    return;
                }

                self.addMenuList.push({
                    menuNo: "",
                    storeNo: self.storeInfo.storeNo,
                    menuName: menuName,
                    menuCategory: "",
                    menuInfo: "",
                    menuPrice: menuPrice,
                    reqTime: 30,
                    mStatus: "Y"
                });

                self.addMenuInput = {
                    menuName: "",
                    menuPrice: ""
                };
            },

            fnRemoveAddMenu: function(index) {
                let self = this;

                self.addMenuList.splice(index, 1);
            },

            fnSaveAddMenuList: function() {
                let self = this;

                if (self.addMenuList.length === 0) {
                    alert("추가할 메뉴를 먼저 입력해주세요.");
                    return;
                }

                for (let i = 0; i < self.addMenuList.length; i++) {
                    if (!self.addMenuList[i].menuName) {
                        alert("메뉴명이 비어있는 메뉴가 있습니다.");
                        return;
                    }

                    if (!self.addMenuList[i].menuPrice || Number(self.addMenuList[i].menuPrice) < 1000) {
                        alert("가격은 1000원 이상 입력해주세요.");
                        return;
                    }
                }

                let sendList = self.addMenuList.map(function(item) {
                    return {
                        menuNo: 0,
                        storeNo: Number(item.storeNo || self.storeInfo.storeNo),
                        menuName: item.menuName,
                        menuCategory: item.menuCategory || "",
                        menuInfo: item.menuInfo || "",
                        menuPrice: Number(item.menuPrice),
                        reqTime: Number(item.reqTime || 30),
                        mStatus: item.mStatus || "Y"
                    };
                });

                $.ajax({
                    url: "/biz/store/menu/update.dox",
                    type: "POST",
                    dataType: "json",
                    contentType: "application/json",
                    data: JSON.stringify({
                        menuList: sendList,
                        deleteMenuNoList: []
                    }),
                    success: function(data) {
                        if (data.result === "success") {
                            alert("메뉴가 추가되었습니다.");
                            self.fnCloseMenuAddModal();
                            self.fnGetMenuList();
                        } else {
                            alert(data.message || "메뉴 추가에 실패했습니다.");
                        }
                    },
                    error: function() {
                        alert("메뉴 추가 중 오류가 발생했습니다.");
                    }
                });
            },

            fnRemoveMenu: function(item) {
                let self = this;

                if (!confirm("이 메뉴를 삭제하시겠습니까?")) {
                    return;
                }

                if (item.menuNo && Number(item.menuNo) !== 0) {
                    self.deleteMenuNoList.push(Number(item.menuNo));
                }

                self.editMenuList = self.editMenuList.filter(menu => menu !== item);
            },

            fnCloseMenuEditModal: function() {
                let self = this;
                self.showMenuEditModal = false;
            },

            fnSetMainImage: function(fileNo) {
                let self = this;

                $.ajax({
                    url: "/biz/store/image/main.dox",
                    type: "POST",
                    dataType: "json",
                    data: { fileNo: fileNo },
                    success: function(data) {
                        if (data.result === "success") {
                            alert("대표 이미지가 설정되었습니다.");
                            self.fnGetFileList();
                        } else {
                            alert(data.message || "대표 이미지 설정에 실패했습니다.");
                        }
                    },
                    error: function() {
                        alert("서버 오류가 발생했습니다.");
                    }
                });
            },

            fnDeleteImage: function(fileNo) {
                let self = this;

                if (!confirm("이미지를 삭제하시겠습니까?")) {
                    return;
                }

                $.ajax({
                    url: "/biz/store/image/delete.dox",
                    type: "POST",
                    dataType: "json",
                    data: { fileNo: fileNo },
                    success: function(data) {
                        if (data.result === "success") {
                            alert("삭제되었습니다.");
                            self.fnGetFileList(); // 리스트 다시 불러오기
                        } else {
                            alert(data.message || "삭제 실패");
                        }
                    },
                    error: function() {
                        alert("서버 오류");
                    }
                });
            },

            fnUploadImage: function (event) {
                let self = this;
                const file = event.target.files[0];

                if (!file) {
                    return;
                }

                if (!self.storeInfo.storeNo) {
                    alert("업체 정보가 아직 없습니다. 새로고침 후 다시 시도해주세요.");
                    event.target.value = "";
                    return;
                }

                if (self.fileList.length >= 4) {
                    alert("이미지는 최대 4개까지 등록할 수 있습니다.");
                    event.target.value = "";
                    return;
                }

                if (!file.type.startsWith("image/")) {
                    alert("이미지 파일만 업로드할 수 있습니다.");
                    event.target.value = "";
                    return;
                }

                let formData = new FormData();
                formData.append("file", file);
                formData.append("storeNo", self.storeInfo.storeNo);
                formData.append("sUserId", window.storeEditConfig.sessionId);

                $.ajax({
                    url: "/biz/store/image/upload.dox",
                    type: "POST",
                    dataType: "json",
                    data: formData,
                    processData: false,
                    contentType: false,
                    enctype: "multipart/form-data",
                    success: function (data) {
                        if (data.result === "success") {
                            alert("이미지가 등록되었습니다.");
                            event.target.value = "";
                            self.fnGetFileList();   // 이미지 목록 다시 조회
                        } else {
                            alert(data.message || "이미지 등록에 실패했습니다.");
                            event.target.value = "";
                        }
                    },
                    error: function () {
                        alert("업로드 중 오류가 발생했습니다.");
                        event.target.value = "";
                    }
                });
            },

            fnSaveRejectedStore: function() {
                let self = this;

                if (!self.editStoreInfo.sAddr) {
                    alert("주소를 입력해주세요.");
                    return;
                }

                if (self.isGeocoding) {
                    alert("주소 좌표를 가져오는 중입니다. 잠시 후 다시 저장해주세요.");
                    return;
                }

                if (self.editStoreInfo.lat === "" || self.editStoreInfo.lng === "" ||
                    self.editStoreInfo.lat == null || self.editStoreInfo.lng == null) {
                    alert("주소의 위도/경도를 가져오지 못했습니다. 주소검색을 다시 진행해주세요.");
                    return;
                }

                let param = {
                    storeNo: self.editStoreInfo.storeNo,
                    storeName: self.editStoreInfo.storeName,
                    sCategory: self.editStoreInfo.sCategory,
                    biznum: self.editStoreInfo.biznum,
                    accName: self.editStoreInfo.accName,
                    accNo: self.editStoreInfo.accNo,
                    accHolder: self.editStoreInfo.accHolder,
                    sAddr: self.editStoreInfo.sAddr,
                    sFullAddr: self.editStoreInfo.sFullAddr,
                    lat: self.editStoreInfo.lat ? Number(self.editStoreInfo.lat) : null,
                    lng: self.editStoreInfo.lng ? Number(self.editStoreInfo.lng) : null
                };

                $.ajax({
                    url: "/biz/store/reapply.dox",
                    type: "POST",
                    dataType: "json",
                    data: param,
                    success: function(data) {
                        if (data.result === "success") {
                            alert("재신청되었습니다.");
                            self.fnCloseRejectedStoreModal();
                            self.fnCheckApprovedStore();
                        } else {
                            alert(data.message || "재신청에 실패했습니다.");
                        }
                    },
                    error: function() {
                        alert("재신청 처리 중 오류가 발생했습니다.");
                    }
                });
            },

            fnSaveStoreInfo: function() {
                let self = this;

            if (!self.editStoreInfo.cutoff || self.editStoreInfo.cutoff < 1 || self.editStoreInfo.cutoff > 72) {
                alert("예약 마감 시간은 1~72 사이의 숫자만 입력할 수 있습니다.");
                return;
            }

            if (Number(self.editStoreInfo.slot) !== 30 && Number(self.editStoreInfo.slot) !== 60) {
                alert("예약 단위는 30분 또는 60분만 선택할 수 있습니다.");
                return;
            }

            self.editStoreInfo.openTime = self.fnMakeTimeFromParts(
                self.editStoreInfo.openAmpm,
                self.editStoreInfo.openHour,
                self.editStoreInfo.openMinute
            );

            self.editStoreInfo.closeTime = self.fnMakeTimeFromParts(
                self.editStoreInfo.closeAmpm,
                self.editStoreInfo.closeHour,
                self.editStoreInfo.closeMinute
            );

            if (!self.editStoreInfo.openTime || !self.editStoreInfo.closeTime) {
                alert("운영 시작시간과 운영 종료시간을 모두 선택해주세요.");
                return;
            }

            let openMinutes = self.fnTimeToMinutes(self.editStoreInfo.openTime);
            let closeMinutes = self.fnTimeToMinutes(self.editStoreInfo.closeTime);

            if (closeMinutes <= openMinutes) {
                alert("운영 종료시간은 운영 시작시간보다 늦어야 합니다.");
                return;
            }

            if (self.fnHasAnyBreakPart("breakStart") || self.fnHasAnyBreakPart("breakEnd")) {
                if (!self.fnIsBreakPartComplete("breakStart") || !self.fnIsBreakPartComplete("breakEnd")) {
                    alert("브레이크타임은 시작과 종료의 오전/오후, 시간, 분을 모두 선택하거나 모두 비워주세요.");
                    return;
                }

                self.editStoreInfo.breakStart = self.fnMakeTimeFromParts(
                    self.editStoreInfo.breakStartAmpm,
                    self.editStoreInfo.breakStartHour,
                    self.editStoreInfo.breakStartMinute
                );

                self.editStoreInfo.breakEnd = self.fnMakeTimeFromParts(
                    self.editStoreInfo.breakEndAmpm,
                    self.editStoreInfo.breakEndHour,
                    self.editStoreInfo.breakEndMinute
                );
            }

            if ((self.editStoreInfo.breakStart && !self.editStoreInfo.breakEnd) ||
                (!self.editStoreInfo.breakStart && self.editStoreInfo.breakEnd)) {
                alert("브레이크타임은 시작시간과 종료시간을 모두 입력하거나, 둘 다 비워주세요.");
                return;
            }

            if (self.editStoreInfo.breakStart && self.editStoreInfo.breakEnd) {
                let slot = Number(self.editStoreInfo.slot);
                let breakStartMinutes = self.fnTimeToMinutes(self.editStoreInfo.breakStart);
                let breakEndMinutes = self.fnTimeToMinutes(self.editStoreInfo.breakEnd);

                if (breakEndMinutes <= breakStartMinutes) {
                    alert("브레이크 종료시간은 시작시간보다 늦어야 합니다.");
                    return;
                }

                if ((breakEndMinutes - breakStartMinutes) % slot !== 0) {
                    alert("브레이크타임은 예약 단위에 맞게 선택해주세요.");
                    return;
                }

                if (openMinutes != null && closeMinutes != null) {
                    if (breakStartMinutes < openMinutes || breakEndMinutes > closeMinutes) {
                        alert("브레이크타임은 운영시간 안에서 선택해주세요.");
                        return;
                    }
                }
            }

            if (!self.editStoreInfo.sAddr) {
                alert("주소를 입력해주세요.");
                return;
            }

            if (self.isGeocoding) {
                alert("주소 좌표를 가져오는 중입니다. 잠시 후 다시 저장해주세요.");
                return;
            }

            if (self.editStoreInfo.lat === "" || self.editStoreInfo.lng === "" ||
                self.editStoreInfo.lat == null || self.editStoreInfo.lng == null) {
                alert("주소의 위도/경도를 가져오지 못했습니다. 주소검색을 다시 진행해주세요.");
                return;
            }

            let param = {
                storeNo: self.editStoreInfo.storeNo,
                isOpen: self.editStoreInfo.isOpen,
                accName: self.editStoreInfo.accName,
                accNo: self.editStoreInfo.accNo,
                accHolder: self.editStoreInfo.accHolder,
                sAddr: self.editStoreInfo.sAddr,
                sFullAddr: self.editStoreInfo.sFullAddr,
                subTitle: self.editStoreInfo.subTitle,
                sContents: self.editStoreInfo.sContents,
                capacity: self.editStoreInfo.capacity,
                cutoff: Number(self.editStoreInfo.cutoff),
                openTime: self.editStoreInfo.openTime,
                closeTime: self.editStoreInfo.closeTime,
                breakStart: self.editStoreInfo.breakStart,
                breakEnd: self.editStoreInfo.breakEnd,
                slot: Number(self.editStoreInfo.slot),
                refundPolicy: self.editStoreInfo.refundPolicy,
                lat: self.editStoreInfo.lat ? Number(self.editStoreInfo.lat) : null,
                lng: self.editStoreInfo.lng ? Number(self.editStoreInfo.lng) : null
            };

                let saveUrl = self.storeInfo.sStatus === "REJ"
                    ? "/biz/store/reapply.dox"
                    : "/biz/store/update.dox";

                $.ajax({
                    url: saveUrl,
                    type: "POST",
                    dataType: "json",
                    data: param,
                    success: function(data) {
                        if (data.result === "success") {
                            alert("업체 정보가 수정되었습니다.");
                            self.fnCloseStoreEditModal();
                            self.fnGetStoreInfo();
                        } else {
                            alert(data.message || "업체 정보 수정에 실패했습니다.");
                        }
                    },
                    error: function() {
                        alert("업체 정보 수정 중 오류가 발생했습니다.");
                    }
                });
            },

            fnSaveMenuList: function() {
                let self = this;

                let sendList = self.editMenuList.map(function(item) {
                    return {
                        menuNo: Number(item.menuNo || 0),
                        storeNo: Number(item.storeNo || self.storeInfo.storeNo),
                        menuName: item.menuName,
                        menuCategory: item.menuCategory || "",
                        menuInfo: item.menuInfo || "",
                        menuPrice: Number(item.menuPrice || 0),
                        reqTime: Number(item.reqTime || 30),
                        mStatus: item.mStatus
                    };
                });

                $.ajax({
                    url: "/biz/store/menu/update.dox",
                    type: "POST",
                    dataType: "json",
                    contentType: "application/json",
                    data: JSON.stringify({
                        menuList: sendList,
                        deleteMenuNoList: self.deleteMenuNoList
                    }),
                    success: function(data) {
                        if (data.result === "success") {
                            alert("업체 메뉴가 수정되었습니다.");
                            self.fnCloseMenuEditModal();
                            self.fnGetMenuList();
                        } else {
                            alert(data.message || "업체 메뉴 수정에 실패했습니다.");
                        }
                    },
                    error: function() {
                        alert("업체 메뉴 수정 중 오류가 발생했습니다.");
                    }
                });
            },

            fnEditMyInfo: function() {
                let self = this;

                self.editUserInfo = {
                    sUserId: self.userInfo.sUserId,
                    ceoName: self.userInfo.ceoName,
                    sUserPwd: "",
                    sUserPwdConfirm: ""
                };

                self.isIdChecked = false;
                self.showMyInfoEditModal = true;
            },

            fnResetIdCheck: function() {
                this.isIdChecked = false;
            },

            fnCheckBizUserId: function() {
                let self = this;
                let param = {
                    sUserId: self.editUserInfo.sUserId,
                };

                if (!self.editUserInfo.sUserId) {
                    alert("아이디를 입력해주세요.");
                    return;
                }

                $.ajax({
                    url: "/checkBizUserId.dox",
                    type: "POST",
                    dataType: "json",
                    data: param,
                    success: function(data) {
                        if (data.result === "success") {
                            if (data.exists) {
                                alert("이미 사용 중인 아이디입니다.");
                                self.isIdChecked = false;
                            } else {
                                alert("사용 가능한 아이디입니다.");
                                self.isIdChecked = true;
                            }
                        } else {
                            alert(data.message || "중복 확인에 실패했습니다.");
                        }
                    },
                    error: function() {
                        alert("중복 확인 중 오류가 발생했습니다.");
                    }
                });
            },

            fnSaveMyInfo: function() {
                let self = this;

                if (!self.editUserInfo.sUserId) {
                    alert("아이디를 입력해주세요.");
                    return;
                }

                if (self.editUserInfo.sUserId !== self.userInfo.sUserId && !self.isIdChecked) {
                    alert("아이디 중복 확인을 해주세요.");
                    return;
                }

                if (!self.editUserInfo.sUserPwd) {
                    alert("새 비밀번호를 입력해주세요.");
                    return;
                }

                if (!self.editUserInfo.sUserPwdConfirm) {
                    alert("비밀번호 확인을 입력해주세요.");
                    return;
                }

                if (self.editUserInfo.sUserPwd !== self.editUserInfo.sUserPwdConfirm) {
                    alert("비밀번호와 비밀번호 확인이 일치하지 않습니다.");
                    return;
                }

                let param = {
                    sUserId: self.editUserInfo.sUserId,
                    sUserPwd: self.editUserInfo.sUserPwd
                };

                $.ajax({
                    url: "/biz/user/update.dox",
                    type: "POST",
                    dataType: "json",
                    data: param,
                    success: function(data) {
                        if (data.result === "success") {
                            alert("내 정보가 수정되었습니다.");
                            self.fnCloseMyInfoModal();
                            self.fnGetMyInfo();
                        } else {
                            alert(data.message || "내 정보 수정에 실패했습니다.");
                        }
                    },
                    error: function() {
                        alert("내 정보 수정 중 오류가 발생했습니다.");
                    }
                });
            },

            fnCloseMyInfoModal: function() {
                let self = this;

                self.showMyInfoEditModal = false;
                self.isIdChecked = false;

                self.editUserInfo = {
                    sUserId: "",
                    ceoName: "",
                    sUserPwd: "",
                    sUserPwdConfirm: ""
                };
            },

            fnOpenPostcode: function() {
                let self = this;

                self.showPostcodeLayer = true;

                self.$nextTick(function() {
                    let postcodeWrap = document.getElementById("postcodeWrap");

                    if (!postcodeWrap) {
                        alert("주소 검색 영역을 찾을 수 없습니다.");
                        return;
                    }

                    postcodeWrap.innerHTML = "";

                    new daum.Postcode({
                        oncomplete: function(data) {
                            let address = data.roadAddress || data.address;

                            self.editStoreInfo.sAddr = address;
                            self.editStoreInfo.sFullAddr = "";
                            self.editStoreInfo.lat = "";
                            self.editStoreInfo.lng = "";

                            if (!window.kakao || !kakao.maps || !kakao.maps.services) {
                                alert("카카오 지도 서비스를 불러오지 못했습니다. JavaScript 키와 도메인 설정을 확인하세요.");
                                return;
                            }

                            self.isGeocoding = true;

                            let geocoder = new kakao.maps.services.Geocoder();

                            geocoder.addressSearch(address, function(result, status) {
                                self.isGeocoding = false;

                                if (status === kakao.maps.services.Status.OK && result && result.length > 0) {
                                    self.editStoreInfo.lng = result[0].x; // 경도
                                    self.editStoreInfo.lat = result[0].y; // 위도

                                    self.fnClosePostcode();
                                } else {
                                    alert("선택한 주소의 위도/경도를 가져오지 못했습니다. 주소를 다시 선택해주세요.");
                                }
                            });
                        },
                        width: "100%",
                        height: "100%"
                    }).embed(postcodeWrap);
                });
            },

            fnClosePostcode: function() {
                let self = this;

                self.showPostcodeLayer = false;

                let postcodeWrap = document.getElementById("postcodeWrap");
                if (postcodeWrap) {
                    postcodeWrap.innerHTML = "";
                }
            },

            fnCheckCutoff: function() {
                let self = this;

                if (self.editStoreInfo.cutoff < 1) {
                    self.editStoreInfo.cutoff = 1;
                }

                if (self.editStoreInfo.cutoff > 72) {
                    self.editStoreInfo.cutoff = 72;
                }
            },

        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            self.fnGetMyInfo();
            self.fnCheckApprovedStore();
            
        }
    });

    app.mount('#app');