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

var check_interval = 15;
var last_checked = 0;

function init_yield_container(){
    var yield_container = $('#yield-container');
    var datepickers = $(".datepicker",yield_container);
    datepickers.datetimepicker({
        format: 'dd-MM-yyyy',
        language: 'es',
        pickTime: false
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
        init_yield_container();

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

        // buscar notificaciones cada 15 segundos
        last_checked = (new Date()).getTime() / 1000 | 0;
        window.setTimeout(updateNotifications, check_interval * 1000);
    }
)

function updateNotifications() {
    console.info('Buscando notificaciones...');
    $.getJSON('/api/logs/show.json?start=' + last_checked, function(data) {
        console.info('Encontrado ' + data.length + ' notificaciones.');
        var $notif_template = $('#realtime-notification-template').clone();
        $notif_template.attr('id', '');
        $notif_template.removeClass('hide');

        var $container = $('#realtime-notification-container');
        $container.slideUp('slow', function() {
            $container.empty();
            // actualizar
            for (var i = 0; i < data.length; i++) {
                var $notif = $notif_template.clone();
                $notif.append(data[i]['message']);
                $container.append($notif);
            }

            $container.slideDown('slow');
        }); // slideUp
    }) // getJSON
        .always(function() {
            // volver a revisar en 15 segundos
            window.setTimeout(updateNotifications, check_interval * 1000);
        });

    last_checked = (new Date()).getTime() / 1000 | 0;
}