package filter;

import java.io.IOException;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import model.User;
import java.util.Arrays;
import java.util.List;

public class AdminFilter implements Filter {

    // Allowed roles for /admin/* endpoints
    private static final List<String> ALLOWED_ROLES = Arrays.asList("ADMIN");

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpSession session = req.getSession(false);

        if (session != null) {
            User user = (User) session.getAttribute("user");
            if (user != null && ALLOWED_ROLES.contains(user.getRole())) {
                // User is allowed - allow access
                chain.doFilter(request, response);
                return;
            }
        }

        // Not allowed - redirect to error page
        req.setAttribute("error", "Access Denied: Admin privileges required");
        req.getRequestDispatcher("/common/error.jsp").forward(req, response);
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void destroy() {
    }
}
