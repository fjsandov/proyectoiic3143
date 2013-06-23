// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require html5shiv
//= require jquery
//= require jquery_ujs
//= require jquery.ui.all
//= require twitter/bootstrap
//= require bootstrap
//= require select2
//= require_tree .

// parametros realtime notifications
var check_interval = 15;
var last_checked = 0;
var stop_checks = false;

function init_yield_container(){
    var yield_container = $('#yield-container');
    var datepickers = $(".datepicker",yield_container);
    datepickers.datetimepicker({
        format: 'dd-MM-yyyy',
        language: 'es',
        pickTime: false
    });

    var timepickers = $(".timepicker",yield_container);
    timepickers.datetimepicker({
        format: 'HH:mm PP',
        language: 'es',
        pick12HourFormat: true,
        pickSeconds: false,
        pickDate: false
    });

    var datetimepickers = $('.datetimepicker',yield_container);
    datetimepickers.datetimepicker({
        format: 'dd-MM-yyyy HH:mm PP',
        language: 'es',
        pick12HourFormat: true,
        pickSeconds: false
    });

    var select2s = $('.select2',yield_container);
    select2s.select2();
}

$(
    function(){
        //---------------------------------------I18N de datetimepicker----------------------------------------------//
        $.fn.datetimepicker.dates['es'] = {
            days: ["Domingo", "Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado", "Domingo"],
            daysShort: ["Dom", "Lun", "Mar", "Mié", "Jue", "Vie", "Sáb", "Dom"],
            daysMin: ["Do", "Lu", "Ma", "Mi", "Ju", "Vi", "Sa", "Do"],
            months: ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre",
                "Noviembre", "Diciembre"],
            monthsShort: ["Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"],
            today: "Hoy",
            suffix: [],
            meridiem: []
        };

        //-------------------------------------------I18N de select2------------------------------------------------//
        $.extend($.fn.select2.defaults, {
            formatNoMatches: function () { return "No se encontraron resultados"; },
            formatInputTooShort: function (input, min) { var n = min - input.length;
                return "Por favor adicione " + n + " caracter" + (n == 1? "" : "es"); },
            formatInputTooLong: function (input, max) { var n = input.length - max;
                return "Por favor elimine " + n + " caracter" + (n == 1? "" : "es"); },
            formatSelectionTooBig: function (limit) {
                return "Solo puede seleccionar " + limit + " elemento" + (limit == 1 ? "" : "s"); },
            formatLoadMore: function (pageNumber) { return "Cargando más resultados..."; },
            formatSearching: function () { return "Buscando..."; }
        });

        init_yield_container();

        // buscar notificaciones cada 15 segundos
        last_checked = (new Date()).getTime() / 1000 | 0;
        updateNotifications();
    }
)

// esta funcion se llama a si misma (async) cada 15 segs.
function updateNotifications() {
    if (stop_checks)
        return; // esto mata todos los updates futuros tambien

    console.info('Buscando notificaciones...');
    $.getJSON('/api/logs/show.json?start=' + last_checked, function(data) {
        console.info('Encontrado ' + data.length + ' notificaciones.');
        if (data.length > 0) {
            var $notif_template = $('<li><a><i class="icon-info-sign"></i> </a></li>');
            var $container = $('#realtime-notification-container');

            // sacar mensaje de que no hay notificaciones
            $('#dummy-notification').remove();

            // actualizar
            for (var i = 0; i < data.length; i++) {
                var $notif = $notif_template.clone();
                $notif.find('a').append(data[i]['message']);
                $container.prepend($notif);
            }
            $('#realtime-notification-counter').html($container.children().length);
        }
    }) // getJSON
        .always(function() {
            // volver a revisar en 15 segundos
            window.setTimeout(updateNotifications, check_interval * 1000);
        });

    last_checked = (new Date()).getTime() / 1000 | 0;
}