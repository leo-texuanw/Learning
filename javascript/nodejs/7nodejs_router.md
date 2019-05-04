### [Node.js Router](http://www.runoob.com/nodejs/nodejs-router.html)
我们要为路由提供 请求的URL和其他需要的GET及POST参数，随后路由需要根据这些数据来执行相应的代码。
我们需要的所有数据都会包含在request对象中，该对象作为onRequest()回调函数的第一个参数传递。但是为了解析这些数据，我们需要额外的Node.JS模块，它们分别是url和querystring模块。

现在我们来给onRequest()函数加上一些逻辑，用来找出浏览器请求的URL路径：

``` javascript
    var http = require("http");
    var url = require("url");

    function start() {
        function onRequest(request, response) {
            var pathname = url.parse(request.url).pathname;
            console.log("Request for " + pathname + " received.");
            response.writeHead(200, {"Content-Type": "text/plain"});
            response.write("Hello World");
            response.end();
        }

        http.createServer(onRequest).listen(8888);
        console.log("Server has started.");
    }

    exports.start = start;
```

建立 router.js
``` javascript
    function route(pathname) {
        console.log("About to route a request for " + pathname);
    }

    exports.route = route;
```

首先，我们来扩展一下服务器的start()函数，以便将路由函数作为参数传递过去，server.js 文件代码如下

``` javascript
    var http = require("http");
    var url = require("url");

    function start(route) {
        function onRequest(request, response) {
            var pathname = url.parse(request.url).pathname;
            console.log("Request for " + pathname + " received.");

            route(pathname);

            response.writeHead(200, {"Content-Type": "text/plain"});
            response.write("Hello World");
            response.end();
        }

        http.createServer(onRequest).listen(8888);
        console.log("Server has started.");
    }

    exports.start = start;
```
同时，我们会相应扩展index.js，使得路由函数可以被注入到服务器中：

``` javascript
    var server = require("./server");
    var router = require("./router");

    server.start(router.route);
```

在这里，我们传递的函数依旧什么也没做。
如果现在启动应用（node index.js，始终记得这个命令行），随后请求一个URL，你将会看到应用输出相应的信息，这表明我们的HTTP服务器已经在使用路由模块了，并会将请求的路径传递给路由：

    $ node index.js
    Server has started.
以上输出已经去掉了比较烦人的/favicon.ico请求相关的部分。
