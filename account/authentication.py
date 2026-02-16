from rest_framework.authentication import SessionAuthentication


class CsrfExemptSessionAuthentication(SessionAuthentication):
    """
    SessionAuthentication without CSRF protection for API endpoints
    """
    def enforce_csrf(self, request):
        return  # Do not enforce CSRF