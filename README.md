# Cookmate AI - Recipe Generator App

A Flutter application that generates recipes using AI. The app helps users create and discover new recipes based on their preferences and available ingredients.

## Features

- AI-powered recipe generation
- Save favorite recipes
- Share recipes with friends
- Vegetarian/Non-vegetarian filter
- Category-based recipe browsing
- User-friendly interface

## Setup Requirements

1. Flutter SDK (3.7.0 or higher)
2. Gemini API key (for AI features)
3. Required assets in `assets/images/`:
   - default_recipe.png (400x200, placeholder for recipes without images)
   - cooking_icon.png (50x50, used in recipe detail screen)
   - start_cooking_icon.png (30x30, used in home screen)
   - welcome_image.png (400x400, used in login screen)

   Note: All images should be in PNG format with transparency support where needed.
   You can use any appropriate images that match these dimensions and your app's design.

## Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/cookmate-ai.git
   cd cookmate-ai
   ```

2. Create a .env file in the root directory:
   ```
   GEMINI_API_KEY=your_api_key_here
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Add required image assets:
   - Place all required images in the `assets/images/` directory
   - Ensure images are named exactly as specified above

5. Run the app:
   ```bash
   flutter run
   ```

## Architecture

- `lib/models/` - Data models
- `lib/providers/` - State management using Provider
- `lib/screens/` - UI screens
- `lib/services/` - Business logic and API services
- `lib/widgets/` - Reusable UI components
- `lib/constants/` - App constants and configurations

## Contributing

1. Fork the repository
2. Create a new branch
3. Make your changes
4. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.
