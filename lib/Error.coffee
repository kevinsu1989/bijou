class HTTPStatusError
  constructor: (@status, @message, @code)->
  toJSON: ()-> message: @message, code: @code

exports.HTTPStatusError = HTTPStatusError

#响应错误
exports.responseError = (err, res)->
  if err instanceof HTTPStatusError
    switch err.status
      when 406 then return this.notAcceptable err.toJSON(), res
      when 404 then return this.notFound res

  #数据库错误
  res.statusCode = 500
  res.json err

#向客户端响应404消息
exports.notFound = (res)->
  res.statusCode = 404
  res.end '404 Not Found'

#响应未授权
exports.unauthorized = (res)->
  res.statusCode = 401
  res.end '401 Unauthorized'

#响应数据格式不对
exports.notAcceptable = (data, res)->
  res.statusCode = 406

  if(typeof data is 'object')
    res.json data
  else
    res.end data || ''