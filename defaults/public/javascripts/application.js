// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

jQuery.fn.slideFadeToggle = function(speed, easing, callback)
{
    return this.animate({opacity: 'toggle', height: 'toggle'}, speed, easing, callback);
};

var filterIsOn = false;

function initCalendars()
{
      $(".date_field").each(function() {
        $(this).datepicker({showOn: 'button', buttonImage: '/images/icons/calendar.png', buttonImageOnly: true, dateFormat:'yy-mm-dd', showAnim: 'drop' });
    });
}

function addHoverBehaviourToRows()
{
    $('tr').hover(
            function () {
                $(this).find('div').fadeIn(200);
            },
            function () {
                $(this).find('div').fadeOut(200);
            }
            );
}

$(document).ready(function ()
{

    addHoverBehaviourToRows();


    $("a[icon='add']").click(function() {
        if (filterIsOn)
        {
            $('#filter').fadeToggle();
            filterIsOn = false;
        }
        $('#table').fadeOut();
        $('#new').slideFadeToggle();
        return false;
    });

    $("a[icon='filter']").click(function() {
        $('#filter').slideFadeToggle();
        $(this).fadeToggle();
        filterIsOn = true;
        return false;
    });


    $(".frame .bt_close").click(function() {
        if (filterIsOn)
        {
            $('#filter').slideFadeToggle();
            $("a[icon='filter']").fadeToggle();
            filterIsOn = false;
        }
        else
        {
            $('#table').fadeIn();
            $('#new').slideFadeToggle();
            $("a[icon='filter']").fadeIn();
        }
        return false;
    });

    $(".emboss_frame .bt_close").click(function() {
        $(this).parents('.emboss_frame').slideFadeToggle('normal', function()
        {
            $(this).remove();
        }
        );
        return false;
    });    

    initCalendars();

    /*

    disabled - because new elements didnt inherit it

    $('.remove_line').hover(
            function () {
                $(this).find('img').animate({
                    opacity: 1
                }, 200);
            },
            function () {
                $(this).find('img').animate({
                    opacity: 0.5
                }, 200);
            }
            );
     */
});

function remove_fields(link) {

    $(link).parents('fieldset.invoice_line').slideFadeToggle('normal', function() {
    $(link).parents('ol').first().find("input[name$='[_destroy]']").val("1");
      //$(link).parents('fieldset.invoice_line').remove();
    });



}

function add_fields(link, association, content) {
    var new_id = new Date().getTime();
    var regexp = new RegExp("new_" + association, "g");
    //$(link).parent().before(content.replace(regexp, new_id));
    $(link).parent("form").find("input[name$='[_destroy]']").parents(".invoice_line:last").after(content.replace(regexp, new_id));

    $(link).parent("form").find("input[name$='[_destroy]']").parents(".invoice_line:last").hide();
    $(link).parent("form").find("input[name$='[_destroy]']").parents(".invoice_line:last").slideFadeToggle();
    initInvoiceCalculations();
}


$(function () {
    //$("#osx-modal-data").tree();
});


function scopeHoursToUserAndProject(user_id, project_id) {
    $("select[id$='search_for_users']").val(user_id);
    $("select[id$='search_for_projects']").val(project_id);
    $("select[id$='search_grouped_by_scope']").val("Project");
    $("input[id$='search_include_time_entries']").attr('checked', true);
    $("form[id$='time_entries_filter']").submit();
}

function setRangeForFields(range_start_id, range_end_id, value_start, value_end)
{
    $("input[id$='" + range_start_id + "']").effect("highlight", {}, 1000);
    $("input[id$='" + range_end_id + "']").effect("highlight", {}, 1000);
    $("input[id$='" + range_start_id + "']").val(value_start);
    $("input[id$='" + range_end_id + "']").val(value_end);
}

function clearForm(ele){
    ele.find(':input').each(function() {
        switch(this.type) {
            case 'password':
            case 'select-multiple':
            case 'select-one':
            case 'text':
            case 'textarea':
                $(this).val('');
                break;
            case 'checkbox':
            case 'radio':
                this.checked = false;
        }
    });
}


function addIdToPayablesSet(el){
      var myregexp = /\d+/;
      var mymatch = myregexp.exec(el.id);
      if (!window.selected_ids){
          window.selected_ids = [];
          }
    if (el.checked && window.selected_ids.indexOf(mymatch[0]) == -1)
    {
      window.selected_ids.push(mymatch[0]);
    }
    
    if (!el.checked)
    {
      window.selected_ids[window.selected_ids.indexOf(mymatch[0])] = window.selected_ids[window.selected_ids.length-1];
      window.selected_ids.pop();
    }

    if (window.selected_ids.length != 0 && $('#link_set_payable > a').css('display') == "none")
    {
        $('#link_set_payable > a').fadeIn();
    }
    if (window.selected_ids.length == 0 && $('#link_set_payable > a').css('display') != "none")
    {
        $('#link_set_payable > a').fadeOut();
    }


}

function updateInvoiceLines(proj_id,name,type,ids)
{
    /*
     1) Znalezc pola payable_id, ktorych id zawiera ids
     2) wypenic je id
     3) Znalezc pola payable_type, ktorych id zawiera ids
     4) wypelnic je 'Project'
     5) Znalezc pola invoice_line_name, ktorych id zawiera ids
     6) Wypenic ich hinty name
    */
    for (var i=0; i < ids.length; i++) {
        $('input[id*='+ids[i]+']').filter('[id$=payable_type]').val(type);
        $('input[id*='+ids[i]+']').filter('[id$=payable_id]').val(proj_id);
        $('input[id*='+ids[i]+']').filter('[id$=name]').siblings().html(name);
    }
}

function adjustBodyCellsWidthToHead()
{
    $(document).ready(function ()
    {
        $('th[id^=team_edit_membership]').each(function() {
            var name  = $(this).attr("id");
            var width = $(this).width();
            $('td[class='+name+']').width(width);
        });
    });
}