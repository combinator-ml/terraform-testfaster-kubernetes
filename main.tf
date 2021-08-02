/*
This module represents a request for testfaster VM with an optional conformant
kubernetes cluster of a given version, implicitly creating a pool of the given
configuration.
*/

resource "random_id" "random" {
    byte_length = 8
}

resource "local_file" "testfaster_yaml" {
    content = yamlencode({
      "name": var.name,
      "base": {
        "kernel_image": var.kernel_image,
        "os_dockerfile": var.os_dockerfile,
        "docker_bake_script": var.docker_bake_script,
        "preload_docker_images": var.preload_docker_images,
        "prewarm_script": var.prewarm_script,
        "kubernetes_version": var.kubernetes_version,
      },
      "runtime": {
        "cpus": var.cpus,
        "memory": var.memory,
        "disk": var.disk,
      },
      "prewarm_pool_size": var.prewarm_pool_size,
      "max_pool_size": var.max_pool_size,
      "default_lease_timeout": var.default_lease_timeout,
    })
    filename = "${path.module}/${random_id.random.hex}/.testfaster.yml"
}

resource "null_resource" "testfaster_vm" {
    depends_on = [local_file.testfaster_yaml]
    provisioner "local-exec" {
        command = <<-EOT
            cd ${path.module}/${random_id.random.hex}
            mkdir -p bin
            curl -sSL -o ./bin/testctl \
                https://storage.googleapis.com/get-faster-ci/$(uname -sm |sed 's/ /-/')/testctl
            chmod +x ./bin/testctl
            ./bin/testctl login --token ${var.testfaster_token} --endpoint ${var.testfaster_endpoint}
            ./bin/testctl get --name vm-${random_id.random.hex} --endpoint ${var.testfaster_endpoint}
        EOT
    }
}

data "local_file" "kubeconfig" {
    filename = "${path.module}/${random_id.random.hex}/kubeconfig"
    depends_on = [null_resource.testfaster_vm]
}

output "kubeconfig" {
    value = data.local_file.kubeconfig.content
    depends_on = [null_resource.testfaster_vm]
}
