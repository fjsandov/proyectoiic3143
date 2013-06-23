// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function()
{
    $("#add_new_shift_link").click(function()
    {
        $.ajax({
            type: "GET",
            url: "/personal/turnos/nuevo_turno",
            data: { },
            success: function(data)
            {
                $('#shift_form_panel').html(data);
                init_shift_form_js();
            }
            ,
            error: function (jqXHR, textStatus, errorThrown)
            {
                console.error("OCURRIO EL SIGUIENTE ERROR: " + textStatus, errorThrown);
            }
        });
    });
});

function init_shift_form_js()
{
    $('#add_task_button').click(function()
    {
        $('#tasks_collection :selected').each(function(i, selected)
        {
            var  opt = $('<option></option>');
            opt.val($(selected).val());
            opt.text($(selected).text());
            $('#shift_tasks_collection').append(opt);

            $(selected).remove();
        });
    });

    $('#remove_task_button').click(function()
    {
        $('#shift_tasks_collection :selected').each(function(i, selected)
        {
            var  opt = $('<option></option>');
            opt.val($(selected).val());
            opt.text($(selected).text());
            $('#tasks_collection').append(opt);

            $(selected).remove();
        });
    });

    init_yield_container();
}