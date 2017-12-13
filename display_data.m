function display_data(hObject,handles)

handles.current_frame = read(handles.video_obj,handles.video_framenumber);
set(handles.framenumbertext,'String',sprintf('Frame: %04d/%04d',handles.video_framenumber,handles.last_frame_number))
imshow(handles.current_frame);
if ~isempty(handles.result)
	current_rows = handles.result(handles.video_framenumber>=handles.result.FrameNumber,:);
	current_IDs = unique(current_rows.ID);
for current_ID = current_IDs'
	if any(handles.result.ID==current_ID & handles.result.FrameNumber==handles.video_framenumber)
		current_position=table2array(handles.result(handles.result.ID==current_ID & handles.result.FrameNumber==handles.video_framenumber,4:7));
        current_edgecolor='b';
	elseif any(handles.result.ID==current_ID & handles.result.FrameNumber > max(current_rows(current_rows.ID==current_ID,:).FrameNumber)) && ~isempty(min(handles.result(handles.result.ID==current_ID & handles.result.FrameNumber > handles.video_framenumber,:).FrameNumber))
		before_position_with_framenum=table2array(current_rows(current_rows.ID==current_ID & current_rows.FrameNumber == max(current_rows(current_rows.ID==current_ID,:).FrameNumber),[2, 4:7]));
		after_position_with_framenum=table2array(handles.result(handles.result.ID==current_ID & handles.result.FrameNumber == min(handles.result(handles.result.ID==current_ID & handles.result.FrameNumber > handles.video_framenumber,:).FrameNumber),[2, 4:7]));
		current_position = interpolate_position_size(before_position_with_framenum(2:5),...
			after_position_with_framenum(2:5),...
			before_position_with_framenum(1),...
			after_position_with_framenum(1),...
			handles.video_framenumber);
        current_edgecolor='k';
	else
		current_position=table2array(current_rows(current_rows.ID==current_ID & current_rows.FrameNumber == max(current_rows(current_rows.ID==current_ID,:).FrameNumber),4:7));
        current_edgecolor='r';
	end
	rectangle('position', current_position,'linestyle', '-','edgecolor',current_edgecolor,'UserData',current_ID);
end
end
drawnow
guidata(hObject, handles);
end