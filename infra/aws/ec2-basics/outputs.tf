output publicIp {
    # value = aws_instance.app.public_ip
    value = { for k, inst in aws_instance.app : k => inst.public_ip }
}

output publicKey {
    value = tls_private_key.my_rsa_key.public_key_pem
}

output "postgres_db_enpoint" {
  value = aws_db_instance.postgres.endpoint
}