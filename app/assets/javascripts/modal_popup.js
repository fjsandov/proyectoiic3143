$(
    function(){
        var $modal_popup =  $('#modal-popup');
        $modal_popup.on('shown', function () {
            initModal();
            /*----------------------------COMPORTAMIENTO DE FORMULARIOS EN MODAL--------------------------------*/
            var frm = $('form',$modal_popup);
            frm.submit(function (event) {
                //Evita que ocurra el comportamiento por defecto.
                event.preventDefault();
                $.ajax({
                    type: frm.attr('method'),
                    url: frm.attr('action'),
                    data: frm.serialize(),
                    success: function(data) {
                        $modal_popup.removeData('modal');
                        $('.modal-body').replaceWith(data);
                        initModal();
                    },
                    error: function (jqXHR, textStatus, errorThrown){
                        console.error("OCURRIO EL SIGUIENTE ERROR: " + textStatus, errorThrown);
                    }
                });
            });
        });
        /*----------------------------FIN COMPORTAMIENTO DE FORMULARIOS EN MODAL--------------------------------*/

        /*---------------------PARA QUE AL CARGAR UN 2° MODAL POPUP, SE VUELVAN A PEDIR LOS DATOS---------------------*/
        $modal_popup.on('hidden',function(){
            $(this).removeData('modal');
            var default_modal_body = '<div class="modal-body"><img class = "loading-img" src="/assets/images/cargando.gif"></div>';
            $('.modal-body').replaceWith(default_modal_body);
        });

        //------------------------------------------------I18N de datetimepicker-----------------------------------------------------//
        $.fn.datetimepicker.dates['es'] = {
            days: ["Domingo", "Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado", "Domingo"],
            daysShort: ["Dom", "Lun", "Mar", "Mié", "Jue", "Vie", "Sáb", "Dom"],
            daysMin: ["Do", "Lu", "Ma", "Mi", "Ju", "Vi", "Sa", "Do"],
            months: ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"],
            monthsShort: ["Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"],
            today: "Hoy",
            suffix: [],
            meridiem: []
        };


        /*---Aplica datepicker JQUERY UI a quien tenga la clase datepicker dentro del contenido cargado en el popup---*/
        function initModal(){
            var datepickers = $(".datepicker");
            if(datepickers.length>0){
                datepickers.datepicker({ dateFormat: 'dd-mm-yy' });
            }

            var datetimepickers = $('.datetimepicker');
            if(datetimepickers.length>0) {
                datetimepickers.datetimepicker({
                        format: 'dd-MM-yyyy HH:mm PP',
                        language: 'es',
                        pick12HourFormat: true,
                        pickSeconds: false
                    });
            }
        }
})
