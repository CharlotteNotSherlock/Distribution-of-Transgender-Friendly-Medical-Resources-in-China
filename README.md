# Distribution-of-Transgender-Friendly-Medical-Resources-in-China

Static Mapbox visualization of transgender-friendly medical resources in China.

## Deploy to GitHub Pages

This repository is configured to deploy with GitHub Actions.

1. Go to your repository settings on GitHub.
2. Open `Settings -> Secrets and variables -> Actions`.
3. Create a new repository secret named `MAPBOX_TOKEN`.
4. Open `Settings -> Pages` and set Source to `GitHub Actions`.
5. Push to `main` to trigger deployment.

The workflow injects the token into `index.html` at deploy time and publishes the site artifact to GitHub Pages.

## Security Notes

- The token is not stored in repository source.
- Because this is a client-side map, the token will still be visible in deployed page source.
- In Mapbox dashboard, restrict token usage to your GitHub Pages domain and required APIs only.
- Rotate `MAPBOX_TOKEN` in GitHub Secrets if exposure is suspected.