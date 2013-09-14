///<reference path="/Scripts/jquery-1.7.1.min.js"/>
///<reference path="/Scripts/spine.js"/>

var Confirm = Spine.Controller.sub({
    elements: {
        "input[name=BankName]": "BankName",
        "input[name=Url]": "Url"
    },

    events: {
        "keyup input[name=BankName]": "updateUrl"
    },

    init: function () {
    },

    updateUrl: function (event) {
        var url = this.BankName.val()
            .replace(/ /g, "")
            .replace(/[^A-Za-z1-9]/,"")
            .toLowerCase();
        this.Url.val(url);
    }
});

$(document).ready(function () {
    var c = new Confirm({ el: $("#confirm") });
});
