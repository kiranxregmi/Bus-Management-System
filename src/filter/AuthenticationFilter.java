package filter;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebFilter("/*")
public class AuthenticationFilter implements Filter {

    private static final List<String> PUBLIC_URLS = Arrays.asList(
            "/login.jsp", "/register.jsp", "/index.jsp", "/about.jsp", "/contact.jsp",
            "/css/", "/js/", "/images/", "/common/",
            "/login", "/register", "/logout", "/bus", "/customer/searchResults.jsp");

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        String requestURI = req.getRequestURI();
        String contextPath = req.getContextPath();
        String path = requestURI.substring(contextPath.length());

        // Check if URL is public
        boolean isPublic = false;
        for (String publicUrl : PUBLIC_URLS) {
            if (path.startsWith(publicUrl) || path.equals(publicUrl)) {
                isPublic = true;
                break;
            }
        }

        // Allow access to static resources
        if (path.startsWith("/css/") || path.startsWith("/js/") || path.startsWith("/images/")) {
            isPublic = true;
        }

        if (isPublic) {
            // Public URL - allow access
            chain.doFilter(request, response);
        } else {
            // Protected URL - check authentication
            if (session != null && session.getAttribute("user") != null) {
                // User is logged in - allow access
                chain.doFilter(request, response);
            } else {
                // Not logged in - store requested URL and redirect to login
                session = req.getSession(true);
                session.setAttribute("redirectAfterLogin", path);
                res.sendRedirect(contextPath + "/login.jsp");
            }
        }
    }

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
    }

    @Override
    public void destroy() {
    }
}
