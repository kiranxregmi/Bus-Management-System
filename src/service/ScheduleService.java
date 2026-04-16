package service;

import dao.ScheduleDAO;
import dao.BusDAO;
import model.Schedule;
import model.Bus;
import java.sql.Date;
import java.sql.SQLException;
import java.sql.Time;
import java.util.List;

public class ScheduleService {
    private ScheduleDAO scheduleDAO = new ScheduleDAO();
    private BusDAO busDAO = new BusDAO();

    public boolean addSchedule(Schedule schedule) throws SQLException {
        // Validation: departure before arrival
        if (schedule.getDepartureTime().after(schedule.getArrivalTime())) {
            throw new IllegalArgumentException("Departure time must be before arrival time.");
        }

        // Validation: travel date not in past
        Date today = new Date(System.currentTimeMillis());
        if (schedule.getTravelDate().before(today)) {
            // Check if it's actually today (same date comparison)
            if (!schedule.getTravelDate().toString().equals(today.toString())) {
                throw new IllegalArgumentException("Travel date cannot be in the past.");
            }
        }

        // Validation: Bus conflict
        if (scheduleDAO.checkBusConflict(schedule.getBusId(), schedule.getTravelDate(), 
                                        schedule.getDepartureTime(), schedule.getArrivalTime())) {
            throw new IllegalArgumentException("Bus is already scheduled for another trip during this time.");
        }

        // Set available seats from bus capacity if not set
        if (schedule.getAvailableSeats() <= 0) {
            Bus bus = busDAO.getBusById(schedule.getBusId());
            if (bus != null) {
                schedule.setAvailableSeats(bus.getCapacity());
            }
        }

        return scheduleDAO.addSchedule(schedule);
    }

    public List<Schedule> getSchedulesForDate(Date date) throws SQLException {
        return scheduleDAO.getSchedulesByDateRange(date, date);
    }

    public List<Schedule> getSchedulesByRange(Date start, Date end) throws SQLException {
        return scheduleDAO.getSchedulesByDateRange(start, end);
    }

    public Schedule getScheduleById(int id) throws SQLException {
        return scheduleDAO.getScheduleById(id);
    }

    public boolean updateStatus(int id, String status) throws SQLException {
        return scheduleDAO.updateStatus(id, status);
    }

    public boolean updateOperationalDetails(int id, Integer driverId, Integer conductorId, Time actualDep, Time actualArr) throws SQLException {
        boolean staffUpdate = scheduleDAO.updateStaff(id, driverId, conductorId);
        boolean timeUpdate = scheduleDAO.updateActualTimes(id, actualDep, actualArr);
        return staffUpdate || timeUpdate;
    }

    public boolean deleteSchedule(int id) throws SQLException {
        return scheduleDAO.deleteSchedule(id);
    }
}
