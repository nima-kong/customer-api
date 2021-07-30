package userAuthz

default allow = false


allow {
  # Validate JWT token
  v := input.request.http.headers.authorization
  startswith(v, "Bearer ")
  t := substring(v, count("Bearer "), -1)
  io.jwt.verify_hs256(t, data.userAuthz.jwt_signiture)
  [_, payload, _] := io.jwt.decode(t)

  # Validate consumer app
  kong_consumer := input.consumer.username
  some j
  data.userAuthz.apps[j] == kong_consumer

  # Validate network
  net.cidr_contains(data.userAuthz.networkcidr, input.client_ip)


  # Validate user's access to api
	role := data.userAuthz.users[payload.username].role
  serviceName := input.service.name
  access := data.userAuthz.role_service_access[role][serviceName].access
  some i
  access[i] == input.request.http.method

}
