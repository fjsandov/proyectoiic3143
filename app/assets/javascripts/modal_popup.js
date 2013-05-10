
$(
    function(){

        var modal_popup =  $('#modal-popup');

        modal_popup.on('shown', function () {
            /*---Aplica datepicker JQUERY UI a quien tenga la clase datepicker dentro del contenido cargado en el popup---*/
                var datepickers = $(".datepicker");
                if(datepickers.length>0){
                    datepickers.datepicker({ dateFormat: 'dd-mm-yy' });
                }
            /*------------------------------------------------------------------------------------------------------------*/
        })

        /*---------------------PARA QUE AL CARGAR UN 2° MODAL POPUP, SE VUELVAN A PEDIR LOS DATOS---------------------*/
        modal_popup.on('hidden',function(){
            $(this).removeData('modal');
            var default_modal_body = '<div class="modal-body"><img class = "loading-img" src="/assets/images/cargando.gif"></div>';
            $('.modal-body').replaceWith(default_modal_body);
        });
        /*-------------------------------------------------------------------------------------------------------------------------*/
    }
)
