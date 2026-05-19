# Bus Job - Changelog

## [1.0.0] - 2026-05-19

### Added
- Initial release of Realistic Bus Job script
- 4 pre-configured routes (Downtown, Beach, Airport, Suburban)
- Multi-stop passenger pickup/dropoff system
- Realistic fuel consumption mechanic
- Vehicle damage tracking and thresholds
- Speed limit enforcement with penalties
- Passenger boarding animations
- Bus door mechanics (open/close)
- Engine health checking
- Income system with multiple payment types:
  - Base route pay
  - Per-passenger earnings
  - Distance bonuses
  - On-time completion bonus
  - Perfect route bonus
  - Tax system
- Real-time HUD with:
  - Route information
  - Passenger count
  - Speed display
  - Fuel gauge
  - Earnings tracker
  - Time remaining
- GPS navigation with route and stop blips
- Traffic violation system
  - Speeding tickets
  - Penalties for violations
- Player statistics tracking:
  - Total trips completed
  - Total earnings
  - Passengers transported
  - Distance traveled
  - Accidents
  - Speeding tickets
- Comprehensive configuration system
- Command-based job control
- Server-side payment processing
- Professional notification system
- Audio/visual feedback
- Export functions for external integration
- Complete documentation and README
- Debug mode for development

### Features
- Multi-route support with customizable locations
- Automatic bus vehicle management
- Interactive passenger boarding mechanic
- Real-time progress tracking
- Payment logging to server console
- QBX/QBCore integration
- Flexible configuration for all aspects
- Professional HUD display
- Route difficulty levels

### Scripts Included
- `fxmanifest.lua` - Resource manifest
- `shared/config.lua` - Complete configuration
- `client/client.lua` - Main client logic
- `client/utils.lua` - Utility functions
- `client/effects.lua` - Visual & audio effects
- `server/server.lua` - Payment processing
- `server/logs.lua` - Logging system
- `README.md` - Full documentation

### Configuration Options
- Route customization (stops, distances, pay)
- Traffic rule settings (speed limits, penalties)
- Damage system (thresholds, penalties)
- Realistic features (fuel, doors, parking brake)
- Income configuration (bonuses, taxes)
- HUD positioning and visibility
- Notification styling
- Blip configuration
- Localization support

---

## Planned Features (Future Updates)

- [ ] Database integration for persistent stats
- [ ] Leaderboard system (top earners, best drivers)
- [ ] Vehicle customization/upgrades
- [ ] NPC job starter integration (ox_target)
- [ ] Weather-based mission variations
- [ ] Skill progression system
- [ ] Advanced routing optimization
- [ ] Tourist guide mode
- [ ] School bus routes
- [ ] Multi-language support (more languages)
- [ ] Admin panel for configuration
- [ ] Custom route editor GUI
- [ ] Photo mode integration
- [ ] Passenger complaints/ratings
- [ ] Fuel station integration
- [ ] Vehicle maintenance system
- [ ] Callouts/random events
- [ ] Co-driver support (2 drivers per bus)

---

## Version History

### 1.0.0
- First stable release
- All core features implemented
- Full documentation provided
- Ready for production deployment

---

**Author**: lilkerry  
**Framework**: QBX/QBCore  
**Last Updated**: 2026-05-19
