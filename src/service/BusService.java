package service;

import java.sql.Date;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import dao.BusDAO;
import model.Bus;
import model.Schedule;
import util.ValidationUtil;

public class BusService {

    private BusDAO busDAO = new BusDAO();

    public boolean addBus(Bus bus) throws SQLException {
        List<String> errors = validateBus(bus);
        if (!errors.isEmpty()) {
            throw new IllegalArgumentException(String.join(", ", errors));
        }

        return busDAO.addBus(bus);
    }

    public List<Bus> getAllBuses() throws SQLException {
        return busDAO.getAllBuses();
    }

    public Bus getBusById(int id) throws SQLException {
        return busDAO.getBusById(id);
    }

    public List<Schedule> searchBuses(String source, String destination, String dateStr) throws SQLException {
        // Validate inputs
        if (!ValidationUtil.isNotEmpty(source) || !ValidationUtil.isNotEmpty(destination)) {
            throw new IllegalArgumentException("Source and destination are required");
        }

        if (source.equals(destination)) {
            throw new IllegalArgumentException("Source and destination cannot be the same");
        }

        Date travelDate;
        try {
            travelDate = Date.valueOf(dateStr);
        } catch (IllegalArgumentException e) {
            throw new IllegalArgumentException("Invalid date format");
        }

        // Check if date is in the past
        if (travelDate.before(new Date(System.currentTimeMillis()))) {
            throw new IllegalArgumentException("Travel date cannot be in the past");
        }

        return busDAO.searchBuses(source, destination, travelDate);
    }

    public int getBusCount() throws SQLException {
        return busDAO.getBusCount();
    }

    public boolean deleteBus(int id) throws SQLException {
        return busDAO.deleteBus(id);
    }

    private List<String> validateBus(Bus bus) {
        List<String> errors = new ArrayList<>();

        if (!ValidationUtil.isValidBusNumber(bus.getBusNumber())) {
            errors.add("Bus number must be format: XX-000 or XX-0000 (e.g., GA-6006)");
        }

        if (!ValidationUtil.isNotEmpty(bus.getBusName())) {
            errors.add("Bus name is required");
        }

        if (!ValidationUtil.isPositiveNumber(bus.getCapacity())) {
            errors.add("Capacity must be greater than 0");
        }

        if (bus.getFarePerSeat() <= 0) {
            errors.add("Fare per seat must be greater than 0");
        }

        return errors;
    }
}
