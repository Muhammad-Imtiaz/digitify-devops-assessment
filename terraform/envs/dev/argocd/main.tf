module "argocd" {
  source        = "../../../modules/argocd"
  author              = "Imtiaz"
  business_unit       = "digitify"
  environment         = "dev"
}