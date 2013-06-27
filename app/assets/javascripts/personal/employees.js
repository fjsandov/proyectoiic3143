// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

$(function(){
    init_assign_shifts_view();
});

function init_assign_shifts_view()
{
    $('#assign_shift_collection').select2({
        width: "500px"
    });

    $('#shift_assign_calendar').fullCalendar({
        // options
        theme: false,
        buttonText:
        {
            today: 'Hoy',
            week: 'Semanal',
            day: 'Diario'
        },
        firstDay: 1,
        header:
        {
            left: '',
            center: '',
            right: ''
        },
        defaultView: 'basicWeek',
        weekMode: 'variable',
        monthNames: ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio',
            'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'],
        monthNamesShort: ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep',
            'Oct', 'Nov', 'Dic'],
        dayNames: ['Domingo', 'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado'],
        dayNamesShort: ['Dom', 'Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb'],
        titleFormat: { week: ''},
        columnFormat:{  week: 'dddd' },
        // sources
        events: function(start, end, callback)
        {
            $.ajax({
                type: "GET",
                url: '/personal/get_shifts',
                data: { id: $('#shift_assign_calendar').attr('data-id')},
                success: function(data)
                {
                    var shifts = [];
                    var events = [];
                    for(var i = 0; i < data.length; i++)
                    {
                        shifts.push(data[i]['id']);

                        for(var j = 0; j < data[i]['start_times'].length; j++)
                        {
                            events.push({
                                id: data[i]['id'] + '-' + 0,
                                start: data[i]['start_times'][j],
                                end: data[i]['end_times'][j],
                                allDay: false,
                                title: data[i]['title']
                            });
                        }
                    }

                    $('#assign_shift_collection').select2('val', shifts);

                    //$('#shift_assign_calendar').fullCalendar('renderEvent', events, true);
                    callback(events);
                }
            });
        }
    });

    $("#assign_shift_collection")
        .on("change", function(e)
        {
            $('.selection_shift_form').submit();
        });
}