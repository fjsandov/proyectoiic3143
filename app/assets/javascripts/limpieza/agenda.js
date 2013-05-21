/**
 * Created with JetBrains RubyMine.
 * User: gio
 * Date: 14-05-13
 * Time: 03:01 AM
 * To change this template use File | Settings | File Templates.
 */
//2. Crear listbox AJAX
$(function() {
    $('#zones_collection').change(function() {
        //incrusta html devuelto dentro del <option> sectors
        if($('#zones_collection').val())
        {
            $('#sectors_collection').html('<option value="">Cargando...</option>');
            $.ajax({
                type: "GET",
                url: "/limpieza/agenda/load_zone",
                data: { 'zone': $('#zones_collection').val() },
                success: function(data) {
                    $('#sectors_collection').html('');
                    for(i = 0; i < data['sectors'].length; i++)
                    {
                        var opt = $('<option></option>');
                        opt.val(data['sectors'][i]['id']);
                        opt.text(data['sectors'][i]['name']);
                        $('#sectors_collection').append(opt);
                    }
                }
                ,
                error: function (jqXHR, textStatus, errorThrown){
                    console.error("OCURRIO EL SIGUIENTE ERROR: " + textStatus, errorThrown);
                }
            });
        }
        else
            $('#sectors_collection').html('<option value="">-----</option>');
    });

    $('#calendar_for_agenda').datepicker({
        currentText: 'Hoy',
        dateFormat: 'dd-MM-yyyy',
        dayNames: ["Domingo", "Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado", "Domingo"],
        dayNamesShort: ["Dom", "Lun", "Mar", "Mié", "Jue", "Vie", "Sáb", "Dom"],
        dayNamesMin: ["Do", "Lu", "Ma", "Mi", "Ju", "Vi", "Sa", "Do"],
        firstDay: 1,
        gotoCurrent: true,
        monthNames: ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"],
        monthNamesShort: ["Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"],
        nextText: 'Siguiente',
        prevText: 'Anterior',
        showOtherMonths: true,
        selectOtherMonths: true
    });
});