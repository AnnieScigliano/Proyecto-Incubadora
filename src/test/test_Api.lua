function helloworld(req)
    return {
        status = "200 OK",
        type = "text/plain",
        body = "Hola mundo :)"
    }
    
end

httpd.start({ webroot = "web", auto_index = httpd.INDEX_ALL})
httpd.dynamic(httpd.GET,"/holamundo", helloworld) 
