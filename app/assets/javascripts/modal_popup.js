$(
    function(){

        var $modal_popup =  $('#modal-popup');

        $modal_popup.on('shown', function () {
            /*---Aplica datepicker JQUERY UI a quien tenga la clase datepicker dentro del contenido cargado en el popup---*/
                var datepickers = $(".datepicker");
                if(datepickers.length>0){
                    datepickers.datepicker({ dateFormat: 'dd-mm-yy' });
                }
            /*------------------------------------------------------------------------------------------------------------*/

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
                    },
                    error: function (jqXHR, textStatus, errorThrown){
                        // log the error to the console
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
        /*-------------------------------------------------------------------------------------------------------------------------*/



    }
)
