<%--
  Created by IntelliJ IDEA.
  User: one
  Date: 2019/4/27
  Time: 1:06
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>模拟几万人抢红包</title>
    <script src="js/jquery.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            //模拟3万个异步请求，进行并发
            var max = 300;
            for (var i = 0; i < max; i++) {
                $.ajax({
                    url: "./userRedPacket/grapRedPacket.do",
                    type: 'get',
                    data: {redPacketId: "2", userId: i},
                    //成功回调
                    success: function (result) {

                    }
                })
            }
        });
    </script>
</head>
<body>

</body>
</html>