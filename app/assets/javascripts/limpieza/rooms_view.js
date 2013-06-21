/**
 * Created with JetBrains RubyMine.
 * User: gio
 * Date: 14-05-13
 * Time: 02:45 AM
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
                url: "/limpieza/vista_salas/load_zone",
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

                    fillRoomButtons(data['rooms']);
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

    $('#sectors_collection').change(function() {
        $.ajax({
            type: "GET",
            url: "/limpieza/vista_salas/load_sector",
            data: { 'sector': $('#sectors_collection').val() },
            success: function(data) {
                fillRoomButtons(data);
            }
            ,
            error: function (jqXHR, textStatus, errorThrown){
                console.error("OCURRIO EL SIGUIENTE ERROR: " + textStatus, errorThrown);
            }
        });
    });
});

function fillRoomButtons(data)
{
    $('#rooms_container').html('');
    for(i = 0; i < data.length; i+= 3)
    {
        var row = $('<div></div>');
        row.addClass('row-fluid');
        for(pos = 0; i + pos < data.length && pos < 3; pos++)
        {
            var span = $('<div></div>');
            span.addClass('span4');

            var room = $('<a></a>');
            room.addClass('rooms_button status-' + data[i+pos]['status'] + ' span12');
            room.attr('data-modal', 'true');
            room.attr('href', data[i+pos]['url']);
            room.text(data[i+pos]['name']);
            span.append(room);
            row.append(span);
        }
        $('#rooms_container').append(row);
    }
    init_links_to_modal();
}