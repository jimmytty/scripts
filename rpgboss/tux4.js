function describeItem(name, desc) {

    var lineLength  = 42;
    var spaces      = new Array(lineLength + 1).join(' ');
    var description = desc;
    if ( description.length > lineLength ) {
        description = description.replace(/(.{30,42})\s/g,"$1\n");
    }
    var title       = (name + ':' + spaces).substr(0, lineLength);
    var text        = title + "\n" + description;
    var maxLines    = text.split(/\n/).length;

    var layout = game.layout(
        game.SOUTH(),
        game.SCALE_SOURCE(),
        1.0,
        1.0
    );
    var params = {
        timePerChar   : 0,
        showArrow     : false,
        linesPerBlock : maxLines,
        justification : 0,
    };

    var window = game.newTextWindow([text], layout, params);

}

function getGeoIP() {
    var url = "http://ipinfo.io/json";
    var json = String(game.httpRequest(url));

    json = json.replace(/^[^{]+{/, '{').replace(/}.*$/, '}');
    json = eval("(function(){return " + json + ";})()");

    return (json);
}

function getGeoIPBr() {
    var url = "http://geoip.s12.com.br";

    var html = String(game.httpRequest(url));
    html = html.replace(/>\s+</g, '><');
    var table = {
        ip: html.match(/<td.*?>IP:<\/td><td.*?>(.*?)<\/td>/),
        city: html.match(/<td.*?>Cidade:<\/td><td.*?>(.*?)<\/td>/),
        region: html.match(/<td.*?>Estado:<\/td><td.*?>(.*?)<\/td>/),
        country: html.match(/<td.*?>País:<\/td><td.*?>(.*?)<\/td>/),
        latitude: html.match(/<td.*?>Latitude:<\/td><td.*?>(.*?)<\/td>/),
        longitude: html.match(/<td.*?>Longitude:<\/td><td.*?>(.*?)<\/td>/),
    };

    for (var key in table) {
        if (null === table[key]) {
            delete table[key];
        }
        else {
            table[key] = table[key][1].replace(/<.*?>/g, '');
        }
    }

    var json = getGeoIP();
    table['org'] = json['org'];

    return (table);
}

function showGeoIP() {
    var json = getGeoIPBr();
    var city;
    if (json.country != '') {
        city = json.country;
        if (json.region != '') {
            city = json.region + ' - ' + city;
            if (json.city != '') {
                city = json.city + '/' + city;
            }
        }
    }

    var msg = [
        'IP:          ' + json.ip,
        'Localização: ' + city,
        'ISP:         ' + json.org,
    ];
    game.showText(msg);
}

function showTextDigited(msgLine, waitTime, lineMax) {
    var msgLines   = msgLine.split("\n");
    var lineLength = 40;
    var spaces     = new Array(lineLength + 1).join(' ');

    if ( lineMax === undefined ) { lineMax = 5; }

    var layout = game.layout(
        game.CENTERED(),
        game.SCALE_SOURCE(),
        1.0,
        1.0
    );
    var charWriteSleep = 0.06;
    var params = {
        timePerChar   : charWriteSleep,
        showArrow     : false,
        linesPerBlock : lineMax,
        justification : 1,
    };

    while ( msgLines.length ) {
        var msgParagraph = msgLines.splice(0, lineMax);

        var lineString   = msgParagraph.join("\n");
        if ( lineString.length < lineLength ) {
            lineString = (lineString + spaces).substr(0, lineLength);
        }
        var window = game.newTextWindow([lineString], layout, params);
        if ( waitTime == -1 ) {
            var key = game.getKeyInput([4, 5, 8, 9]);
        }
        else { game.sleep(waitTime); }
        window.close();
    }

}

function showTextReverseScroll(msgLine, waitTime, lineMax) {
    var msgLines     = msgLine.split("\n");
    var lineLength   = 40;
    var spaces       = new Array(lineLength + 1).join(' ');
    if ( lineMax === undefined ) { lineMax = 5; }
    var msgParagraph = new Array(lineMax);
    msgParagraph[0]  = spaces;
    var line         = msgParagraph.join("\n");

    var layout = game.layout(
        game.CENTERED(),
        game.SCALE_SOURCE(),
        1.0,
        1.0
    );
    var charWriteSleep = 0;
    var params = {
        timePerChar   : charWriteSleep,
        showArrow     : false,
        linesPerBlock : lineMax,
        justification : 1,
    };

    while ( msgLines.length ) {
        var line             = msgParagraph.join("\n");
        var window           = game.newTextWindow([line], layout, params);
        var msgParagraphNew  = msgParagraph.slice();
        var currentParagraph = msgLines.splice(0, lineMax);
        while ( currentParagraph.length ) {
            msgParagraphNew.shift();
            msgParagraphNew.push(currentParagraph.shift());
            line = msgParagraphNew.join("\n");
            window.updateLines([line]);
            game.sleep(0.4);
        }

        if ( waitTime == -1 ) {
            var key = game.getKeyInput([4, 5, 8, 9]);
        }
        else {
            game.sleep(waitTime);
        }
        window.close();
    }

}

function showTextSimple(text) {
    var layout = game.layout(
        game.CENTERED(),
        game.SCALE_SOURCE(),
        1.0,
        1.0
    );
    var params = {
        timePerChar   : 0.0,
        showArrow     : false,
        linesPerBlock : text.length - 1,
        justification : 1,
    };

    var window = game.newTextWindow([text.join("\n")], layout, params);
    var key = game.getKeyInput([4, 5, 8, 9]);
    window.close();
}

function testaComando(comando) {
    // This function define an integer global variable name, 'cmdExitStatus'
    // like Unix Shell, i.e., 0 is TRUE
    var globalIntName = "cmdExitStatus";
    var getString = game.getStringInput("Digite o comando: ", 20, "");
    game.setString("cmdShell", getString);

    game.setInt(globalIntName, 127); // Initial status: "Command not found"
    if (game.getString("cmdShell") == comando) {
        game.setInt(globalIntName, 0);
    }
}

function unixTerminal(cmd, output) {

    if (cmd == undefined) {
        if (game.getInt("cmdExitStatus") == 127) {
            cmd = game.getString("cmdShell");
            output = ["sh: command not found: " + cmd];
        }
        else { return; }
    }

    var ps1 = "sh> ";
    var beginLine = ps1;
    var columns = 30;
    var spaces = new Array(30 + 1).join(' ');
    var promptLine = (ps1 + '_' + spaces).substr(0, columns);
    var layout = game.layout(game.CENTERED(), game.SCALE_SOURCE(), 1.0, 1.0);
    var params = {
        timePerChar: 0,
        showArrow: false,
        linesPerBlock: 6,
        justification: 0,
    };
    var window = game.newTextWindow([promptLine], layout, params);

    game.sleep(0.7);
    promptLine = (ps1 + cmd + '_' + spaces).substr(0, columns);
    window.updateLines([promptLine]);
    game.sleep(0.3);
    promptLine = ps1 + cmd + "\n_";
    window.updateLines([promptLine]);
    game.sleep(0.7);

    for (var i = 0; i < output.length; i++) {
        promptLine = promptLine.substr(0, promptLine.length - 1);
        promptLine += output[i] + "\n_";
        window.updateLines([promptLine]);
        game.sleep(0.3);
    }

    promptLine = promptLine.substr(0, promptLine.length - 1);
    promptLine += ps1 + '_';
    window.updateLines([promptLine]);

    var cursorBlinkTimes = 8;
    while (cursorBlinkTimes--) {
        var lastChar = promptLine.substr(-1)
        if (lastChar == '_') {
            promptLine = promptLine.substr(0, promptLine.length - 1)
        } else {
            promptLine += '_';
        }
        window.updateLines([promptLine]);
        game.sleep(0.4);
    }

    window.close();

}
