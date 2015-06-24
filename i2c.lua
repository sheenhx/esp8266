    local id=0
    local sda=2
    local scl=1
    local c
    -- initialize i2c, pin1=sda, pin2=scl
    i2c.setup(id,sda,scl,i2c.SLOW)
    
    -- read dev_addr's content of reg_addr。
    function read_reg(dev_addr,reg_addr)
      i2c.start(id)
      i2c.address(id, dev_addr ,i2c.TRANSMITTER)
      i2c.write(id,reg_addr)
      --i2c.stop(id)
      i2c.start(id)
      i2c.address(id, dev_addr,i2c.RECEIVER)
      c=i2c.read(id,1)
      i2c.stop(id)
      return c
    end

    function write_reg(dev_addr, reg_addr, data)
      i2c.start(id)
      i2c.address(id, dev_addr ,i2c.TRANSMITTER)
      i2c.write(id,reg_addr)
      i2c.write(id,data)
      i2c.stop(id)
    end

    function setup_mpr121()
      --Section A - Controls filtering when data is > baseline.   
        write_reg(0x5A, 0x2B, 0x01)   
        write_reg(0x5A, 0x2C, 0x01)   
        write_reg(0x5A, 0x2D, 0x00)  
        write_reg(0x5A, 0x2E, 0x00)

        --Section B - Controls filtering when data is < baseline.    
        write_reg(0x5A, 0x2F, 0x01)    
        write_reg(0x5A, 0x30, 0x01)    
        write_reg(0x5A, 0x31, 0xFF)    
        write_reg(0x5A, 0x32, 0x02)       

        --Section C - Sets touch and release thresholds for each electrode    
        write_reg(0x5A, 0x41, 0x0F)    
        write_reg(0x5A, 0x42, 0x0A)       
        write_reg(0x5A, 0x43, 0x0F)    
        write_reg(0x5A, 0x44, 0x0A)       
        write_reg(0x5A, 0x45, 0x0F)   
        write_reg(0x5A, 0x46, 0x0A)        
        write_reg(0x5A, 0x47, 0x0F)   
        write_reg(0x5A, 0x48, 0x0A)      
        write_reg(0x5A, 0x49, 0x0F)    
        write_reg(0x5A, 0x4A, 0x0A)       
        write_reg(0x5A, 0x4B, 0x0F)    
        write_reg(0x5A, 0x4C, 0x0A)        
        write_reg(0x5A, 0x4D, 0x0F)    
        write_reg(0x5A, 0x4E, 0x0A)       
        write_reg(0x5A, 0x4F, 0x0F)   
        write_reg(0x5A, 0x50, 0x0A)       
        write_reg(0x5A, 0x51, 0x0F)    
        write_reg(0x5A, 0x52, 0x0A)        
        write_reg(0x5A, 0x53, 0x0F)    
        write_reg(0x5A, 0x54, 0x0A)      
        write_reg(0x5A, 0x55, 0x0F)   
        write_reg(0x5A, 0x56, 0x0A)       
        write_reg(0x5A, 0x57, 0x0F)   
        write_reg(0x5A, 0x58, 0x0A)       


        --Section D   
        --Set the Filter Configuration  
        --Set ESI2    
        write_reg(0x5A, 0x5D, 0x04)  

        --Section E   
        -- Electrode Configuration    
        -- Set ELE_CFG to 0x00 to return to standby mode    
        write_reg(0x5A, 0x5E, 0x0C)  -- Enables all 12 Electrodes

        --Section F   
        --Enable Auto Config and auto Reconfig    
        write_reg(0x5A, 0x7B, 0x0B)     
        write_reg(0x5A, 0x7D, 0xC9)    --USL = (Vdd-0.7)/vdd*256 = 0xC9 @3.3V  
        write_reg(0x5A, 0x7E, 0x82)    --LSL = 0.65*USL = 0x82 @3.3V    
        write_reg(0x5A, 0x7F, 0xB5)  --Target = 0.9*USL = 0xB5 @3.3V        

     end 

   tmr.alarm(2, 1000, 0, function()
      setup_mpr121()
    end)

    tmr.alarm(1, 1000, 1, function()
      local reg = read_reg(0x5A, 0x00) -- read pressed register 1
      local reg2 = read_reg(0x5A, 0x01)-- read pressed register 2
      m:publish("/relayr/button", "Pressed:"..string.byte(reg)..","..string.byte(reg2),0,0)
   end)
    
    