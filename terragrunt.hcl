terraform {
    extra_arguments "volterra" {
        commands = ["apply","plan","destroy"]
        arguments = []
        env_vars = {
            VES_P12_PASSWORD  = "hb9rwm"

            # prod
            # VOLT_API_URL     = "https://playground.console.ves.volterra.io/api"
            # VOLT_API_P12_FILE = "/home/mwiget/playground.console.ves.volterra.io.api-creds.p12"
	          # VOLTERRA_TOKEN    = "DJeYMuv8l1piCeJdkvyme9JndMU="

            VOLT_API_TIMEOUT  = "60s"

            # staging
            VOLT_API_URL     = "https://playground.staging.volterra.us/api"
            VOLT_API_P12_FILE = "/home/mwiget/playground.staging.api-creds.p12"
            VOLT_API_CA_CERT  = "/home/mwiget/.ves-internal/staging/cacerts/public_server_ca.crt"
	          VOLTERRA_TOKEN    = "JTQkfv6Qiy56/jMAPL+avwbVwy4="
        }
    }

    # after_hook "experiment" {
    #     commands = ["apply","plan","destroy"]
    #     execute  = ["echo","-----------------!!!!!!!!!!!!!!!!! SUPER DONE !!!!!!!!!!!!!!!!!-----------------"]
    # }

}

inputs = {
    projectPrefix          = "mwdcg"
    namespace              = "mwdcg"
    trusted_ip             = "23.88.44.163/32"  # falk1
    volterraTenant         = "playground"
    volterraCloudCredAzure = "m-azure"
    azureRegion1           = "westus2"
    azureRegion2           = "westus2"
    ssh_public_key       = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDr1zH+NmWzf/+qtCTqC/+QAHoWIoq3k3YjH/IsjYdHXZ0mQonsMlrL+owArvLtvi3gXxqPGlO/aWt53v8KAY+RV7IOSbqfFY56k0GTmvPJisSsBkAedruu05hqlFMS/2mkNFL/BsWNzL617LtuFQpN6ud57QSrQruQQtIKTuWUe+XjqkSNiAkvD4zc4tip9ovULhC9QY/IVmhguVDJ0FuQWCDd4l7IM+KjlTXGplN5Y9bIVuU+nnSHnUEkRFxuGX1pvOHB1L31INlD9CVJHDA6bBJyIQgv0WcqoA2/3/8eRqN/pXOe+clglJGRT6bb/+5Sfy6JZoA0OlsyW66VfGR3 mwiget@xeon"
}
