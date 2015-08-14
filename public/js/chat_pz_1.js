$(function() {
    $('form.chat_form button[type="submit"]').click(function(event) {
        event.preventDefault();
        event.stopPropagation();

        var $form = $(event.currentTarget).closest('form.chat_form');


        $.post('/send?' + $form.serialize(), function(data, textStatus, jqXHR) {
            $form.find('input[name="message"]').val('');
        });
    });

    var wsUri = 'ws://localhost:8080';

    var ws_chat_1 = new WebSocket(wsUri);
    var ws_chat_2 = new WebSocket(wsUri);
    var ws_chat_3 = new WebSocket(wsUri);

    ws_chat_1.onopen = function(evt) {
        console.log('Open connection chat 1!');
    };
    ws_chat_2.onopen = function(evt) {
        console.log('Open connection chat 2!');
    };
    ws_chat_3.onopen = function(evt) {
        console.log('Open connection chat 3!');
    };

    ws_chat_1.onclose = function(evt) {
        console.log('CLOSE connection chat 1!');
    };
    ws_chat_2.onclose = function(evt) {
        console.log('CLOSE connection chat 2!');
    };
    ws_chat_3.onclose = function(evt) {
        console.log('CLOSE connection chat 3!');
    };

    ws_chat_1.onerror = function(evt) {
        console.log('ERROR chat 1!!!');
    };
    ws_chat_2.onerror = function(evt) {
        console.log('ERROR chat 2!!!');
    };
    ws_chat_3.onerror = function(evt) {
        console.log('ERROR chat 3!!!');
    };

    var template = _.template("<dt><%- user_name %></dt><dd><%- message %></dd>");

    ws_chat_1.onmessage = function(evt) {
        var html = template(JSON.parse(evt.data));
        $('#chat_1 dl').append(html);
        console.log('=====================');
        console.log('MESSAGE recived to chat 1!');
        console.log(evt);
        console.log('=====================');
    };
    ws_chat_2.onmessage = function(evt) {
        var html = template(JSON.parse(evt.data));
        $('#chat_2 dl').append(html);
        console.log('=====================');
        console.log('MESSAGE recived to chat 2!');
        console.log(evt);
        console.log('=====================');
    };
    ws_chat_3.onmessage = function(evt) {
        var html = template(JSON.parse(evt.data));
        $('#chat_3 dl').append(html);
        console.log('=====================');
        console.log('MESSAGE recived to chat 3!');
        console.log(evt);
        console.log('=====================');
    };
});
