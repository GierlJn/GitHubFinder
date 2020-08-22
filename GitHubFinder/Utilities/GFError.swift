
import Foundation

enum GFError: String, Error{
    case invalidUsername = "This is not an valid username"
    case unableToComplete = "Request could not be completed"
    case invalidResponse = "Invalid response from the server"
    case invalidData = "Data received is not valid"
    case unableToFavorite = "User could not be favored"
    case alreadyInFavorites = "User is already favored"
}
