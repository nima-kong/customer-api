package azuredemo

default allow = false



allow {
  # Validate JWT token
  v := input.request.http.headers.authorization
  startswith(v, "Bearer ")
  t := substring(v, count("Bearer "), -1)
  io.jwt.verify_hs256(t, "B41BD5F462719C6D6118E673A2389")
  [_, payload, _] := io.jwt.decode(t)

  # Validate consumer app
  kong_consumer := input.consumer.username
  some j
  data.azuredemo.apps[j] == kong_consumer

  # Validate network  
  net.cidr_contains(data.azuredemo.networkcidr, input.client_ip)


  # Validate user's access to api
	role := data.azuredemo.users[payload.username].role
  serviceName := input.service.name
  access := data.azuredemo.role_service_access[role][serviceName].access
  some i
  access[i] == input.request.http.method

}
