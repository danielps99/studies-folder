# k3s Configuration for Local Application Access

This configuration allows you to access your applications running on `localhost:PORT` through k3s/kubernetes on `http://localhost/app-PORT`.

## File Structure

Each application has its own file containing all required resources:
- `app-22280.yaml` - Complete configuration for application on port 22280
- `app-22281.yaml` - Complete configuration for application on port 22281
- `app-22282.yaml` - Complete configuration for application on port 22282

Each file contains:
- **Service** - Routes traffic within Kubernetes
- **EndpointSlice** - Points to your host application
- **Middleware** - Strips the `/app-PORT` prefix
- **Ingress** - Exposes the application via Traefik

## Important Note

**Your application must be bound to `0.0.0.0:PORT` (not just `127.0.0.1:PORT`) for k3s pods to access it.**

If your Spring Boot application is currently bound only to localhost, you can change it by:
- Setting `server.address=0.0.0.0` in your application properties, or
- Running with `--server.address=0.0.0.0` flag

## Deployment

1. Ensure your applications are running on their respective ports (22280, 22281, 22282, etc.)
2. Update the IP address in each `app-*.yaml` file if your host IP is different from `10.1.1.21`
3. Apply all configurations:

```bash
# Apply all applications at once
kubectl apply -f app-*.yaml

# Or apply individually
kubectl apply -f app-22280.yaml
kubectl apply -f app-22281.yaml
kubectl apply -f app-22282.yaml
```

## Adding a New Application

### Option 1: Using the Template Script (Recommended)

Use the provided script to generate a new app file from the template:

```bash
./generate-app.sh <PORT> [HOST_IP]
```

**Example:**
```bash
./generate-app.sh 22283
# Generates app-22283.yaml with all values correctly set

# Then apply it:
kubectl apply -f app-22283.yaml
```

The script automatically:
- Sets the service name to `my-app-<PORT>-service`
- Sets the path prefix to `/app-<PORT>`
- Sets all port references
- Uses `10.1.1.21` as default host IP (or specify a different one)

### Option 2: Manual Copy and Replace

1. Copy an existing `app-*.yaml` file:
   ```bash
   cp app-22280.yaml app-22283.yaml
   ```

2. Update all occurrences in the file:
   - Replace `22280` with `22283`
   - Replace `app-22280` with `app-22283`
   - Update the port numbers accordingly

3. Apply the new configuration:
   ```bash
   kubectl apply -f app-22283.yaml
   ```

## Access

After deployment, you can access your applications at:
- `http://localhost/app-22280` (routes to `localhost:22280`)
- `http://localhost/app-22281` (routes to `localhost:22281`)
- `http://localhost/app-22282` (routes to `localhost:22282`)

The Ingress will route traffic to your applications running on the respective ports.

## HTML Server Configuration

The HTML server displays a landing page with links to your applications. It is managed via Kustomize to handle the HTML content updates efficiently.

### Modifying the HTML Page

1. Edit the HTML file located at:
   `apps/html-server/resources/file-to-serve.html`

2. Apply the changes using Kustomize:
   ```bash
   kubectl apply -k .
   ```

   **Important:** This command now applies **ALL** configurations (HTML server + all apps).

3. Kustomize will automatically:
   - Generate a new ConfigMap with a unique hash suffix
   - Update the Deployment to use this new ConfigMap
   - Trigger a rolling restart of the pods to serve the new content immediately
