# Contributing

Thank you for considering contributing!

## Module Guidelines

1. **Security first**: Private by default, encryption enabled
2. **Observability**: Metrics, logging, cost tracking
3. **Documentation**: README, variables, outputs documented
4. **Examples**: Working example for each module

## Process

1. Fork and create feature branch
2. Add tests and documentation
3. Run `terraform fmt` and `terraform validate`
4. Submit PR with description

## Testing

```bash
# Format check
terraform fmt -check -recursive

# Validate all modules
for dir in modules/*/; do
  (cd "$dir" && terraform init -backend=false && terraform validate)
done
```
