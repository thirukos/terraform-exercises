resource "docker_image" "gitea" {
  name         = "gitea/gitea:1.25"
  keep_locally = false
}

resource "docker_container" "gitea" {
  name  = "terraform-basics-gitea"
  image = docker_image.gitea.image_id

  ports {
    internal = 3000
    external = 3000
  }

  ports {
    internal = 22
    external = 2222
  }

  volumes {
    container_path = "/data"
    host_path      = "/tmp/gitea"
  }

  env = [
    "GITEA_database_DB_TYPE=sqlite3",
    "GITEA_database_PATH=/data/gitea/gitea.db"
  ]
}