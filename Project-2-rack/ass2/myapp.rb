class HelloWorld
  def call(env)
    request_method = env['REQUEST_METHOD']
    request_path = env['PATH_INFO']

    response_body = "This is my first web application\nverb = #{request_method}\nroute = #{request_path}\n"

    response = [
      200,
      { 'content-type' => 'text/plain' },
      [response_body]
    ]

    response
  end

end
