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

    $('#shifts_collection').change(function()
    {
        $.ajax({
            type: "GET",
            url: "/personal/turnos/ver_turno",
            data: {
                id: $('#shifts_collection :selected').val()
            },
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
    $('#shift_form_panel form').submit(function()
    {
       $('#shift_tasks_collection option').each(function(i, elem)
       {
           text = $('#task_list').val() + ";" + $(elem).val();
           $('#task_list').val(text);
       });
    });

    init_yield_container();
}