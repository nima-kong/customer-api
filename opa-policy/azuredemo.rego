package azuredemo

import input.request.http

default allow = false



has_BearerToken {
	v := input.request.http.headers.authorization
  startswith(v, "Bearer ")
  t := substring(v, count("Bearer "), -1)
  [_, payload, _] := io.jwt.decode(t)
  payload.username == "alice"
}
