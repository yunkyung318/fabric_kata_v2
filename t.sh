kubectl get secret -n test-network org-orderer1-tls-cert -o json \
    | jq -r '.data["tls.crt"]' \
    | base64 -d \
    > build/channel-msp/orderer1Organizations/org/orderers/org-orderer1/tls/signcerts/tls-cert.pem

