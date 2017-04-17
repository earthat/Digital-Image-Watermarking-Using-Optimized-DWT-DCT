function[watermrkd_img,recmessage,PSNR,IF,NCC,pbest] = BG(cover_object,message)
%%
%Initialization
% clear all   
h=msgbox('Wait while BFO is Computing');
clc
p=4;                         % dimension of search space 
s=6;                        % The number of bacteria 
% s=5000;
Nc=2;                       % Number of chemotactic steps 
Ns=2;                        % Limits the length of a swim 
Nre=1;                       % The number of reproduction steps 
Ned=1;                       % The number of elimination-dispersal events 
Sr=s/2;                      % The number of bacteria reproductions (splits) per generation 
Ped=0.25;                    % The probabilty that each bacteria will be eliminated/dispersed 
c(:,1)=0.05*ones(s,1);       % the run length 

for m=1:s                    % the initital posistions 
    P(1,:,1,1,1)= 10*rand(s,1)';
    P(2,:,1,1,1)= 10*rand(s,1)';
    P(3,:,1,1,1)= 10*rand(s,1)';
    P(4,:,1,1,1)= 10*rand(s,1)';
end                                                                  
     
%%
%Main loop 
    

%Elimination and dispersal loop 
for ell=1:Ned
    

%Reprodution loop


    for K=1:Nre    

%  swim/tumble(chemotaxis)loop   

        for j=1:Nc
            
            for i=1:s        
                [J(i,j,K,ell),watermrkd_img,recmessage,PSNR,IF,NCC]=Live_fn(P(:,i,j,K,ell),cover_object,message);         

% Tumble

                        
                Jlast=J(i,j,K,ell);   
                Delta(:,i)=(2*round(rand(p,1))-1).*rand(p,1); 	             	
                P(:,i,j+1,K,ell)=P(:,i,j,K,ell)+c(i,K)*Delta(:,i)/sqrt(Delta(:,i)'*Delta(:,i)); % This adds a unit vector in the random direction            
 
% Swim (for bacteria that seem to be headed in the right direction)     
                
                [J(i,j+1,K,ell),watermrkd_img,recmessage,PSNR,IF,NCC]=Live_fn(P(:,i,j+1,K,ell),cover_object,message);  
                m=0;         % Initialize counter for swim length 
                    while m<Ns     
                          m=m+1;
                          if J(i,j+1,K,ell)<Jlast  
                             Jlast=J(i,j+1,K,ell);    
                             P(:,i,j+1,K,ell)=P(:,i,j+1,K,ell)+c(i,K)*Delta(:,i)/sqrt(Delta(:,i)'*Delta(:,i)) ;  
                             [J(i,j+1,K,ell),watermrkd_img,recmessage,PSNR,IF,NCC]=Live_fn(P(:,i,j+1,K,ell),cover_object,message);  
                          else       
                             m=Ns ;     
                          end        
                    
                    end 
                J(i,j,K,ell)=Jlast;
                sprintf('The value of interation i %3.0f ,j = %3.0f  , K= %3.0f, ell= %3.0f' , i, j, K ,ell );
                   
            end % Go to next bacterium
            
%             x = P(1,:,j,K,ell);
%             y = P(2,:,j,K,ell);
%             figure(20)
%             clf    
%             plot(x, y , 'h')   
% %             axis([-5 5 -5 5]);
%             pause(.1)
        end  % Go to the next chemotactic    

                 
%Reprodution                                              
        Jhealth=sum(J(:,:,K,ell),2);              % Set the health of each of the S bacteria
        [Jhealth,sortind]=sort(Jhealth);          % Sorts the nutrient concentration in order of ascending 
        P(:,:,1,K+1,ell)=P(:,sortind,Nc+1,K,ell); 
        c(:,K+1)=c(sortind,K);                    % And keeps the chemotaxis parameters with each bacterium at the next generation
                                     

%Split the bacteria (reproduction)                             
            for i=1:Sr
                P(:,i+Sr,1,K+1,ell)=P(:,i,1,K+1,ell); % The least fit do not reproduce, the most fit ones split into two identical copies  
                c(i+Sr,K+1)=c(i,K+1);                 
            end   
        end %  Go to next reproduction    


%Eliminatoin and dispersal
        for m=1:s 
            if  Ped>rand % % Generate random number 
                P(1,:,1,1,1)= 10*rand(s,1)';
                P(2,:,1,1,1)= 10*rand(s,1)';
                P(3,:,1,1,1)= 10*rand(s,1)';
                P(4,:,1,1,1)= 10*rand(s,1)';   
            else 
                P(:,m,1,1,ell+1)=P(:,m,1,Nre+1,ell); % Bacteria that are not dispersed
            end        
        end 
    end % Go to next elimination and disperstal 

%Report
           reproduction = J(:,1:Nc,Nre,Ned);
           [jlastreproduction,O] = min(reproduction,[],2);  % min cost function for each bacterial 
           [Y,I] = min(jlastreproduction);
           pbest=P(:,I,O(I,:),K,ell);
           
         close(h)
end  

                           


                             