<?php
    date_default_timezone_set('America/New_York');
    error_reporting(E_ERROR | E_WARNING | E_PARSE);
    $bgcolor="#FF0000";
    $linkcolor="#FFFFFF";
    $linkcolor="red";
    $ip=$_SERVER['REMOTE_ADDR'];
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
    exec("whois $ip | egrep -i 'net|name' | grep -v arin | grep -v ripe | grep -v abuse ",$who);
    echo "<html><head><title>Hex 7 Internet Solutions</title>";
    if (isset($_GET['refresh']) && ($_GET['refresh'] != "off"))
        { echo "<meta http-equiv=refresh content=20>"; }
    echo "
        <link rel=icon href=\"http://www.hex7.com/favicon.ico\" >
        <link rel=\"shortcut icon\" href=\"http://www.hex7.com/favicon.ico\" >
        <script>
            (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
            (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
            m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
            })(window,document,'script','//www.google-analytics.com/analytics.js','ga');
            ga('create', 'UA-32710227-1', 'auto');
            ga('send', 'pageview');
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
    echo "
        </table>
        <center><br><p><br>
        <p><br><p>
        <table border=0 width=100%><tr>
          <td width=40% align=center>
            <b><font size=5>&copy;2000-2016</font></b><br>
            <a target=_blank href=http://hex7.com>
            <b><font color=red size=+2>Hex 7 Internet Solutions</font></b></a>
          </td>
        </tr></table>
        </center>$os :: <a href=http://en.wikipedia.org/wiki/SOS>s0s</a> at hex7 d0t c0m
        </body>
        </html>
    ";
?>
