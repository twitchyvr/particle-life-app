// Replace line 195 with the correct API call for ImGui 1.89.0
// The method signature has changed - it now returns the clipRect values directly
ImVec4 clipRectValues = drawData.getCmdListCmdBufferClipRect(cmdListIdx, cmdBufferIdx);
clipRect.set(clipRectValues);
