import '../models/category_model.dart';
import '../models/user_model.dart';

class CategoryService {
  static List<Category> getCategories() {
    return [
      // Relationship Categories
      Category(id: '1', name: 'Girlfriend', icon: '❤️', description: 'Romantic partner', isPopular: true),
      Category(id: '2', name: 'Boyfriend', icon: '💑', description: 'Romantic partner', isPopular: true),
      Category(id: '3', name: 'Best Friend', icon: '👫', description: 'Close companion', isPopular: true),

      // Family Categories
      Category(id: '4', name: 'Mother', icon: '👩‍👦', description: 'Parental figure'),
      Category(id: '5', name: 'Father', icon: '👨‍👧', description: 'Parental figure'),
      Category(id: '6', name: 'Sister', icon: '👭', description: 'Sibling companion'),
      Category(id: '7', name: 'Brother', icon: '👬', description: 'Sibling companion'),
      Category(id: '8', name: 'Grandparent', icon: '👴', description: 'Elder companion'),

      // Activity Partners
      Category(id: '9', name: 'Chill Friend', icon: '😎', description: 'Relaxing together', isPopular: true),
      Category(id: '10', name: 'Drink Partner', icon: '🍻', description: 'Bar companion', isPopular: true),
      Category(id: '11', name: 'Walk Partner', icon: '🚶‍♀️', description: 'Walking companion'),
      Category(id: '12', name: 'Talk Partner', icon: '💬', description: 'Conversation partner', isPopular: true),
      Category(id: '13', name: 'Gym Partner', icon: '💪', description: 'Workout companion'),
      Category(id: '14', name: 'Travel Buddy', icon: '✈️', description: 'Travel companion'),
      Category(id: '15', name: 'Movie Buddy', icon: '🎬', description: 'Cinema companion'),
      Category(id: '16', name: 'Concert Buddy', icon: '🎵', description: 'Music event companion'),
      Category(id: '17', name: 'Hiking Partner', icon: '⛰️', description: 'Outdoor adventure'),
      Category(id: '18', name: 'Study Partner', icon: '📚', description: 'Learning companion'),

      // Professional Services
      Category(id: '19', name: 'Plumber', icon: '🔧', description: 'Pipe and fixture services'),
      Category(id: '20', name: 'Electrician', icon: '⚡', description: 'Electrical services'),
      Category(id: '21', name: 'Mechanic', icon: '🔧', description: 'Vehicle repair'),
      Category(id: '22', name: 'Cleaner', icon: '🧹', description: 'Cleaning services'),
      Category(id: '23', name: 'Chef', icon: '👨‍🍳', description: 'Cooking services'),
      Category(id: '24', name: 'Tutor', icon: '👨‍🏫', description: 'Educational services'),
      Category(id: '25', name: 'Photographer', icon: '📷', description: 'Photo services'),
      Category(id: '26', name: 'Driver', icon: '🚗', description: 'Transportation services'),
      Category(id: '27', name: 'Personal Trainer', icon: '💪', description: 'Fitness training'),

      // More categories...
      Category(id: '28', name: 'Gaming Partner', icon: '🎮', description: 'Video game companion'),
      Category(id: '29', name: 'Dance Partner', icon: '💃', description: 'Dancing companion'),
      Category(id: '30', name: 'Shopping Buddy', icon: '🛍️', description: 'Retail therapy partner'),
      Category(id: '31', name: 'Pet Sitter', icon: '🐕', description: 'Animal care'),
      Category(id: '32', name: 'Yoga Partner', icon: '🧘', description: 'Yoga practice'),
      Category(id: '33', name: 'Swimming Partner', icon: '🏊', description: 'Swimming companion'),
      Category(id: '34', name: 'Fishing Buddy', icon: '🎣', description: 'Fishing companion'),
      Category(id: '35', name: 'Gardening Help', icon: '🌻', description: 'Gardening assistance'),
      Category(id: '36', name: 'Tech Support', icon: '💻', description: 'Technology help'),

      // Add more categories as needed...
    ];
  }

  static List<User> getUsersForCategory(String categoryId) {
    // In real app, this would come from API
    return [
      User(
        id: '101',
        name: 'Emma Johnson',
        imageUrl: '',
        age: 25,
        gender: 'Female',
        distance: 1.2,
        rating: 4.8,
        categories: ['1', '3', '9', '12'],
        bio: 'Looking for meaningful connections and fun activities',
        isOnline: true,
      ),
      User(
        id: '102',
        name: 'Michael Chen',
        imageUrl: '',
        age: 28,
        gender: 'Male',
        distance: 2.5,
        rating: 4.9,
        categories: ['2', '3', '11', '13'],
        bio: 'Fitness enthusiast and nature lover',
        isOnline: true,
      ),
      User(
        id: '103',
        name: 'Sophia Rodriguez',
        imageUrl: '',
        age: 45,
        gender: 'Female',
        distance: 0.8,
        rating: 4.7,
        categories: ['4', '6', '18'],
        bio: 'Experienced tutor and caring mentor',
        isOnline: false,
      ),
      User(
        id: '104',
        name: 'David Wilson',
        imageUrl: '',
        age: 32,
        gender: 'Male',
        distance: 3.1,
        rating: 4.6,
        categories: ['5', '7', '19', '21'],
        bio: 'Professional handyman with 10+ years experience',
        isOnline: true,
      ),
      User(
        id: '105',
        name: 'Priya Patel',
        imageUrl: '',
        age: 29,
        gender: 'Female',
        distance: 1.7,
        rating: 4.9,
        categories: ['1', '9', '12', '15'],
        bio: 'Movie buff and coffee lover',
        isOnline: true,
      ),
    ];
  }
}