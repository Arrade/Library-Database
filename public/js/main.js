$(document).ready(function(){
    $('.edit-books').on('click', function(){     
        $('#mediaID').val($(this).data('mediaid'));
        $('#title').val($(this).data('title'));
        $('#genre').val($(this).data('genre'));
        $('#ISBN').val($(this).data('isbn'));
        $('#edition').val($(this).data('edition'));
        $('#language').val($(this).data('language'));
        $('#publisher').val($(this).data('publisher'));
        $('#dateOfPublication').val($(this).data('dateofpublication'));
        $('#pages').val($(this).data('pages'));
        $('#prequelID').val($(this).data('prequelid'));
        $('#sequelID').val($(this).data('sequelid'));
        $('#series').val($(this).data('series'));
        $('#name').val($(this).data('name'));
        $('#contentProducerID').val($(this).data('contentproducerid'));
    });

    $('.edit-users').on('click', function(){     
        $('#userID').val($(this).data('userid'));
        $('#fullName').val($(this).data('fullname'));
        $('#email').val($(this).data('email'));
        $('#bostadsAdress').val($(this).data('bostadsadress'));
        $('#dateOfBirth').val($(this).data('dateofbirth'));
    });
});