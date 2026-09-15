import React, { useState } from 'react';
import { X, Edit3, Clock, Calendar, CheckCircle2, AlertTriangle } from 'lucide-react';

export const EditBlockModal = ({ block, isOpen, onClose, onSave }) => {
  if (!isOpen || !block) return null;

  const [formData, setFormData] = useState({
    scheduled_date: block.scheduled_date || '',
    preferred_start: block.preferred_start || '11:30',
    preferred_end: block.preferred_end || '14:00',
    duration_min: block.duration_min || 150,
    line: block.line || 'UP_MAIN',
    equipment: block.equipment || '',
    crew_size: block.crew_size || 8,
    priority: block.priority || 'HIGH',
    notes: block.notes || 'Time window adjusted to harmonize with freight corridor schedule.'
  });

  const [isSubmitting, setIsSubmitting] = useState(false);

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: name === 'duration_min' || name === 'crew_size' ? Number(value) : value
    }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setIsSubmitting(true);
    try {
      const res = await fetch('/api/divisional/edit-block', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          block_id: block.block_id,
          ...formData
        })
      });
      if (!res.ok) throw new Error('Failed to update block schedule');
      const data = await res.json();
      onSave(data.block);
      onClose();
    } catch (err) {
      alert('Error updating block: ' + err.message);
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <div className="ir-modal-backdrop">
      <div className="ir-modal-content">
        <div className="ir-modal-header">
          <h3>
            <Edit3 size={18} />
            Improvise Maintenance Block Window ({block.block_id})
          </h3>
          <button className="ir-modal-close-btn" onClick={onClose}>
            <X size={20} />
          </button>
        </div>

        <form onSubmit={handleSubmit}>
          <div className="ir-modal-body">
            <div style={{
              background: '#fef3c7',
              border: '1px solid #fde68a',
              borderRadius: '6px',
              padding: '0.75rem',
              marginBottom: '1rem',
              fontSize: '0.82rem',
              color: '#92400e',
              display: 'flex',
              alignItems: 'center',
              gap: '0.5rem'
            }}>
              <AlertTriangle size={18} flexShrink={0} />
              <span>
                <strong>Operational Audit Notice:</strong> Saving changes will mark this block as 
                <strong> "EDITED / MODIFIED BY DIVISIONAL OFFICER"</strong> and timestamp your improvisation.
              </span>
            </div>

            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1rem' }}>
              <div className="ir-form-group">
                <label className="ir-form-label">Department & Work Type</label>
                <input 
                  className="ir-form-input" 
                  value={`${block.department} - ${block.work_type}`} 
                  disabled 
                  style={{ background: '#f8fafc', color: '#64748b' }}
                />
              </div>

              <div className="ir-form-group">
                <label className="ir-form-label">Location / Section</label>
                <input 
                  className="ir-form-input" 
                  value={`${block.section_display || block.section} (${block.block_section})`} 
                  disabled 
                  style={{ background: '#f8fafc', color: '#64748b' }}
                />
              </div>
            </div>

            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr', gap: '1rem' }}>
              <div className="ir-form-group">
                <label className="ir-form-label">Scheduled Date *</label>
                <input
                  type="date"
                  name="scheduled_date"
                  className="ir-form-input"
                  value={formData.scheduled_date}
                  onChange={handleChange}
                  required
                />
              </div>

              <div className="ir-form-group">
                <label className="ir-form-label">Track Line Possession *</label>
                <select
                  name="line"
                  className="ir-form-select"
                  value={formData.line}
                  onChange={handleChange}
                >
                  <option value="UP_MAIN">UP MAIN Line</option>
                  <option value="DN_MAIN">DOWN MAIN Line</option>
                  <option value="BOTH_MAIN">BOTH MAIN Lines (Shadow Possession)</option>
                  <option value="LOOP_LINE">Loop Line / Siding</option>
                </select>
              </div>
            </div>

            <div style={{ display: 'grid', gridTemplateColumns: '1fr 1fr 1fr', gap: '1rem' }}>
              <div className="ir-form-group">
                <label className="ir-form-label">Window Start (HH:MM)</label>
                <input
                  type="time"
                  name="preferred_start"
                  className="ir-form-input"
                  value={formData.preferred_start}
                  onChange={handleChange}
                  required
                />
              </div>

              <div className="ir-form-group">
                <label className="ir-form-label">Window End (HH:MM)</label>
                <input
                  type="time"
                  name="preferred_end"
                  className="ir-form-input"
                  value={formData.preferred_end}
                  onChange={handleChange}
                  required
                />
              </div>

              <div className="ir-form-group">
                <label className="ir-form-label">Duration (Minutes)</label>
                <input
                  type="number"
                  name="duration_min"
                  className="ir-form-input"
                  value={formData.duration_min}
                  onChange={handleChange}
                  min="30"
                  step="15"
                  required
                />
              </div>
            </div>

            <div style={{ display: 'grid', gridTemplateColumns: '1.5fr 1fr 1fr', gap: '1rem' }}>
              <div className="ir-form-group">
                <label className="ir-form-label">Machinery / Equipment Deployed</label>
                <input
                  type="text"
                  name="equipment"
                  className="ir-form-input"
                  value={formData.equipment}
                  onChange={handleChange}
                />
              </div>

              <div className="ir-form-group">
                <label className="ir-form-label">Gang / Crew Size</label>
                <input
                  type="number"
                  name="crew_size"
                  className="ir-form-input"
                  value={formData.crew_size}
                  onChange={handleChange}
                  min="2"
                  max="40"
                />
              </div>

              <div className="ir-form-group">
                <label className="ir-form-label">Priority Class</label>
                <select
                  name="priority"
                  className="ir-form-select"
                  value={formData.priority}
                  onChange={handleChange}
                >
                  <option value="CRITICAL">CRITICAL (Safety)</option>
                  <option value="HIGH">HIGH Priority</option>
                  <option value="MEDIUM">MEDIUM Priority</option>
                  <option value="LOW">LOW Routine</option>
                </select>
              </div>
            </div>

            <div className="ir-form-group">
              <label className="ir-form-label">Divisional Officer Remarks & Improvised Instructions</label>
              <textarea
                name="notes"
                className="ir-form-textarea"
                rows="2"
                value={formData.notes}
                onChange={handleChange}
                placeholder="Specific operational instructions, speed restriction restoration limits, or S&T staff co-location..."
              />
            </div>
          </div>

          <div className="ir-modal-footer">
            <button type="button" className="ir-btn ir-btn-outline" onClick={onClose}>
              Cancel
            </button>
            <button 
              type="submit" 
              className="ir-btn ir-btn-gold" 
              disabled={isSubmitting}
            >
              <CheckCircle2 size={16} />
              {isSubmitting ? 'Saving...' : 'Confirm & Mark as Edited'}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
};
