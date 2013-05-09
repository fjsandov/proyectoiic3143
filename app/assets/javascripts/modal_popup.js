//----------------- PARA QUE AL CARGAR UN MODAL POPUP POR SEGUNDA VEZ, SE VUELVAN A PEDIR LOS DATOS-----------------
$(
    function(){
        /*
        $("a[data-target=#modal-popup]").click(function(ev) {
            ev.preventDefault();
            var target = $(this).attr("href");
            $(".modal-body")
            $(".modal-body").load(target, function() {
                $("#modal-popup").modal("show");
            });
        });        */

        $('#modal-popup').on('hidden',function(){
            $(this).removeData('modal');
            var default_modal_body = '<div class="modal-body"><img class = "loading-img" src="/assets/images/cargando.gif"></div>';
            $('.modal-body').replaceWith(default_modal_body);
        });
    }
)
//------------------------------------------------------------------------------------------------------------------