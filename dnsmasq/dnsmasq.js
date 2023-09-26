
var doDnsmasqStuff = function(event, xhr, options) {
    if (core.curModule("dnsmasq")) {
        setTimeout(function() {
            $(".select-none.no-icon").each(function(i,o){$("<i class='fa fa-minus-square -cs vertical-align-middle' style='margin-right: 8px;'></i>").prependTo($(o)); $(o).removeClass("no-icon")});
            $(".file-chooser-button.no-icon").each(function(i,o){$("<i class='fa fa-fw fa-files-o -cs vertical-align-middle' style='margin-right:5px;'></i>").prependTo($(o)); $(o).removeClass("no-icon")});
            $(".iface-chooser-button.no-icon").each(function(i,o){$("<i class='fa fa2 fa2-plus-network vertical-align-middle' style='margin-right:5px;'></i>").prependTo($(o)); $(o).removeClass("no-icon")}); // adds icon to "new interface" link/button
            $(".add-item-button.no-icon").each(function(i,o){$("<i class='fa fa-plus vertical-align-middle' style='margin-right: 8px; margin: 5px 8px 5px 0px;'></i>").prependTo($(o)); $(o).removeClass("no-icon")}); // adds icon to "new <item>" link/button
            $(".remove-item-button.no-icon").each(function(i,o){$("<i class='fa fa-trash vertical-align-middle' style='margin-right: 8px;'></i>").prependTo($(o)); $(o).removeClass("no-icon")}); // adds icon to "remove <item>" link/button
            $(".add-item-button-small.no-icon").each(function(i,o){$("<i class='fa fa-plus vertical-align-middle' style='margin: 4px;'></i>").prependTo($(o)); $(o).removeClass("no-icon")}); // adds icon to mini "new <item>" button for select box
            $(".remove-item-button-small.no-icon").each(function(i,o){$("<i class='fa fa-trash vertical-align-middle' style='margin: 4px;'></i>").prependTo($(o)); $(o).removeClass("no-icon")}); // adds icon to mini "remove <item>" button for select box
            $(".new-file-input, .new-iface-input").each(function(){$(this).parent().appendTo($(this).parent().prevUntil(".btn-group").last().prev());$(this).parent().prev().css("margin-right", "0px !important");$(this).parent().addClass("new-dnsm-button-container");}); // adds "new file/interface" link to button list
            $(".new-file-input, .new-iface-input").each(function(){replaceWithWrapper($(this), "add", "value", function(obj){$(obj).closest("form").trigger("submit");});}); // submits "new file/interface" button's form when one is selected
            $(".edit-file-input, .edit-iface-input").each(function(){replaceWithWrapper($(this), "edit", "value", function(obj){$(obj).closest("form").trigger("submit");});}); // submits "new file/interface" button's form when one is selected
            $(".clickable_tr").each(function(){$(this).parent().addClass("ui_checked_columns");}); // fixes styling for clickable table row checkboxes
            $(".clickable_tr_selected").each(function(){$(this).removeClass("clickable_tr_selected");$(this).parent().addClass("hl-aw");}); // fixes styling for clickable table row checkboxes
            $("input[dnsmclass=dnsm-type-int]").each(function(){$(this).prop("type", "number");}); // fixes styling for clickable table row checkboxes
            $("input[dummy_field]").hide();
        }, 0);
        $.each($(".show-update-button"), function(){
            var r = $(this).contents();
            $(this)
                .data("toggle", "tooltip")
                .data("title", r)
                .attr("data-container", "body")
                .addClass(vars.h.class.button.tableHeader)
                .removeClass("ui_link")
                .append('<i class="fa fa-update"></i><span>' + "&nbsp;</span>");
            $(this).attr("aria-label", r);
            $(this)
                .contents()
                .filter(function () {
                    return this.nodeType == 3;
                })
                .remove();
            var l = $(this);
            l.tooltip({ container: "body", placement: l.is(":last-child") ? "auto right" : "auto top", trigger: "hover", delay: { show: vars.plugins.tooltip.delay.show, hide: vars.plugins.tooltip.delay.hide } });
        });
        if (!$('#list-item-edit-modal').length) {
            var g='<div class="modal fade fade5 in" id="list-item-edit-modal" tabindex="-1" role="dialog" aria-hidden="true">' +
            '      <div class="modal-dialog">' +
            '        <div class="modal-content" style="padding: 10px;">' +
            // '          <div class="modal-header "><button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">×</span></button><h4 class="modal-title"></h4></div>' +
            '        </div>' +
            '      </div>' +
            '    </div>';
            $(document.body).append(g);
            $("#list-item-edit-modal").on('hidden.bs.modal', function () {
                $(this).data('bs.modal', null);
                $(this).find(".modal-content").html("");
            });
        }
    }
}
var removeDnsmasqStuff = function(event, xhr, options) {
    if (!core.curModule("dnsmasq")) {
        // user is no longer in the dnsmasq module; clean up scripts and css from <head>
        // $("#dnsmasq_css").remove();
        $("script[src*='dnsmasq.js']").remove();
        $(document).off("pjax:end", removeDnsmasqStuff);
        removeDnsmasqStuff = null;
        $(document).off("pjax:end", doDnsmasqStuff);
        doDnsmasqStuff = null;
    }
}
$(document).ready(function() {
    $(document).on("pjax:end", removeDnsmasqStuff);
    $(document).off("pjax:end", doDnsmasqStuff);
    $(document).on("pjax:end", doDnsmasqStuff);
    // if (core.curModule("dnsmasq")) {
    //     if (!document.head.innerHTML.includes("dnsmasq.css")) {
    //         document.head.innerHTML += '<link id="dnsmasq_css" href="dnsmasq.css" rel="stylesheet">';
    //     }
    // }
});

function addItemToSelect(sel){
    if (core.curModule("dnsmasq")) {
        let v=$("input[name="+sel+"_additem]").val();
        if (v) $("select[name="+sel+"]").append($("<option></option>").attr("value",v).text(v));
        $("input[name="+sel+"_additem]").val("");
    }
}
function removeSelectItem(sel){
    if (core.curModule("dnsmasq")) {
        var sItems=[];
        $("select[name="+sel+"]").each(function(){
            sItems.push($(this).val());
        });
        $("select[name="+sel+"]").each(function(i,select){
            $("select[name="+sel+"] option").each(function(ii,option){
                if($(option).val() != "" && sItems[i] == $(option).val() && sItems[i] != $(option).parent().val()){
                    $(option).remove();
                }
            });
        });
    }
}
function submitParentForm(vals, formid) {
    if (core.curModule("dnsmasq")) {
            vals.forEach((o) => {
            let f=o.f;let v=o.v;
            if (f=="submit") return;
            var selector = "#" + formid + " input[name="+f+"]";
            $( selector ).val(v);
        });
        $("#"+formid).submit();
    }
}
function showCustomValidationFailure(obj_name, msg) {
    if (core.curModule("dnsmasq")) {
        let i = $("input[name*="+obj_name+"]").last();
        let badval = i.val();
        i[0].setCustomValidity(msg);
        i[0].addEventListener("input", function(event){ 
            if (i.val()==badval) {
                i[0].setCustomValidity(msg);
            }
            else {
                i[0].setCustomValidity("");
            }
        });
    }
}
function replaceWithWrapper(selector, context, property, callback) {
    if (core.curModule("dnsmasq")) {
        function findDescriptor(obj, prop){
            if (obj != null){
                return Object.hasOwnProperty.call(obj, prop)?
                    Object.getOwnPropertyDescriptor(obj, prop):
                    findDescriptor(Object.getPrototypeOf(obj), prop);
            }
        }

        jQuery(selector).each(function(idx, obj) {
            var {get, set} = findDescriptor(obj, property);

            Object.defineProperty(obj, property, {
                configurable: true,
                enumerable: true,

                get() { //overwrite getter
                    var v = get.call(this);  //call the original getter
                    //console.log("get "+property+":", v, this);
                    return v;
                },

                set(v) { //same for setter
                    var ov = get.call(this);  //call the original getter
                    //console.log("context :", context, this);
                    //console.log("original "+property+":", ov, this);
                    //console.log("set "+property+":", v, this);
                    set.call(this, v);
                    if (context == "add" || (ov && v)) callback(obj, property, v);
                }
            });
        });
    }
}
