<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ include file="header.jsp" %>

        <div class="container" style="text-align: center; padding: 4rem 2rem;">
            <div style="max-width: 500px; margin: 0 auto;">
                <h2 style="color: var(--danger); font-size: 3rem; margin-bottom: 1rem;">⚠️</h2>
                <h2 style="color: var(--primary); margin-bottom: 1rem;">Oops! Something went wrong</h2>

                <% String errorMessage=(String) request.getAttribute("error"); if (errorMessage==null ||
                    errorMessage.isEmpty()) { errorMessage="An unexpected error occurred. Please try again later." ; }
                    %>

                    <div class="error-message" style="margin: 2rem 0;">
                        <%= errorMessage %>
                    </div>

                    <div style="display: flex; gap: 1rem; justify-content: center;">
                        <a href="javascript:history.back()" class="btn"
                            style="width: auto; padding: 0.75rem 2rem; background: var(--gray);">Go Back</a>
                        <a href="${pageContext.request.contextPath}/index.jsp" class="btn"
                            style="width: auto; padding: 0.75rem 2rem;">Go Home</a>
                    </div>
            </div>
        </div>

        <%@ include file="footer.jsp" %>