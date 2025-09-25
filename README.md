# Terraform AWS Lambda CRUD

Infraestructura como código para desplegar una función Lambda que interactúa con Google Sheets.

## ⚠️ **IMPORTANTE - SEGURIDAD**

**NUNCA subas archivos `terraform.tfvars` a Git** - contienen credenciales sensibles.

### Configuración Segura

1. **Copia los archivos de ejemplo:**
   ```bash
   cp envs/dev/terraform.tfvars.example envs/dev/terraform.tfvars
   cp envs/prod/terraform.tfvars.example envs/prod/terraform.tfvars
   ```

2. **Configura tus valores reales** en los archivos `terraform.tfvars`:
   - `spreadsheet_id`: ID de tu Google Sheet
   - `google_credentials_json_base64`: Credenciales de Google en base64

3. **Los archivos `terraform.tfvars` están en `.gitignore`** y no se subirán a Git.

## Uso

### Desarrollo
```bash
cd envs/dev
terraform init
terraform plan
terraform apply
```

### Producción
```bash
cd envs/prod
terraform init
terraform plan
terraform apply
```

## Variables Requeridas

- `spreadsheet_id`: ID de Google Sheets
- `google_credentials_json_base64`: Credenciales de Google en base64
- `jar_path`: Ruta al archivo JAR compilado

## Outputs

- `api_base_url`: URL base de la API Gateway
- `lambda_name`: Nombre de la función Lambda

# Terraform — AWS Lambda + API Gateway CRUD (Java 17)
1) Compila tu jar (proyecto Java): `mvn -q clean package`
2) Edita `envs/dev/terraform.tfvars` con:
   - jar_path
   - spreadsheet_id
   - google_credentials_json_base64
3) `terraform init && terraform apply -var-file=envs/dev/terraform.tfvars`