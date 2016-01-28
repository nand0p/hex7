<?php
    date_default_timezone_set('America/New_York');
    error_reporting(E_ERROR | E_WARNING | E_PARSE);
    $num = rand(1000000,99999999);
    $id = "E" . chr(65 + mt_rand(0, 5));
    $visnum = $id . $num;
    $bgcolor="#FF0000";
    $linkcolor="#FFFFFF";
    $linkcolor="red";
    $ip=$_SERVER['HTTP_X_FORWARDED_FOR'];
    $os=$_SERVER['HTTP_USER_AGENT'];
    $date=date('YMd-D-G:i:s-e');
    $datepage=date('YMd')."<br>".date('D:G:i:s');
    $i = 200;
    $j = 0;
    $k = 0;
    $rows = 55;
    $width = 65;
    $height = 175;
    $density = 80;
    $whitespace = 50;
    exec("whois $ip | egrep -i 'net|name' | grep -v arin | grep -v ripe | grep -v abuse ",$who);
    echo "<html><head><title>Hex 7 Internet Solutions</title>";
    if (isset($_GET['refresh']) && ($_GET['refresh'] != "off"))
        { echo "<meta http-equiv=refresh content=20>"; }
    echo "
        <link rel=icon href=\"http://www.hex7.com/favicon.ico\" >
        <link rel=\"shortcut icon\" href=\"http://www.hex7.com/favicon.ico\" >
        <script type=\"text/javascript\">
            var _gaq = _gaq || [];
            _gaq.push(['_setAccount', 'UA-32710227-1']);
            _gaq.push(['_trackPageview']);
            (function() {
                var ga = document.createElement('script');
                ga.type = 'text/javascript'; ga.async = true;
                #ga.src = ('https:' == document.location.protocol ? 'https://' : 'http://') + 'stats.g.doubleclick.net/dc.js';
                #ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
                var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
            }) ();
        </script>
        <style>
        a { text-decoration: none; color: black; }
        </style>
        </head>
        <body link=$bgcolor vlink=$bgcolor alink=$bgcolor>
        <font name=garamond>
        <center><h1 name=ip>$ip </h1>
        $who[0]<br>$who[1]<br>$who[2]<br>$who[3]
        <p><br>
        <table>
    ";
    for ($j = 0; $j < $i; $j++) {
        echo "<tr>";
        for ($k = 0; $k < $rows; $k++) {
            if (0 == rand(0,$density)) {
                echo "
                    <td height=$height width=$width bgcolor=$bgcolor>
                    <center>&nbsp;
                ";
            }
            else { echo "<td width=$width>"; }
            echo "</td><td>";
        }
        echo "</td></tr>";
    }
    echo "</table>";
    for ($j = 0; $j < $whitespace; $j++) { echo "&nbsp;"; }
    echo "
        </td></tr></table>
        <center><br><p><br>
            <a href=http://serverfault.com/users/190933/nandop>
            <img src=http://serverfault.com/users/flair/190933.png?theme=hotdog
                     width=95% alt=serverfault title=serverfault>
            </a>
        <p><br><p>
        <table border=0 width=100%><tr>
        <td><img src=xtree.gif width=150></td>
        <td width=40% align=center>
        <b><font size=5>&copy;2000-2016</font></b><br>
        <a target=_blank href=http://hex7.com>
        <b><font color=red size=+2>Hex 7 Internet Solutions</font></b></a></td>
        <td><img src=heart.gif width=100></td>
        <td width=40% align=center><b><font size=5>VIN:</font></b><br>
        <font color=red size=+2><b>_-_&nbsp;&nbsp; $visnum &nbsp;&nbsp;_-_</b></font>
        </td><td><img src=xtree.gif width=150></td>
        </td></tr></table>
        </center>$os :: <a href=http://en.wikipedia.org/wiki/SOS>s0s</a> at hex7 d0t c0m
        </body>
        </html>
    ";
?>
